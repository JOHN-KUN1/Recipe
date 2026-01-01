import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:recipe_app/providers/favorite_meal_provider.dart';
import 'package:json_repair_flutter/json_repair_flutter.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:recipe_app/widgets/meal_display.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});
  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  late List _allMeals;
  Future? _loadFavoriteMeals;
  var formattedIngredients = [];


  List _decodeIngredients(String raw) {
    try {
      return jsonDecode(raw) as List;
    } catch (_) {
      try {
        final repaired = repairJson(raw);
        return jsonDecode(repaired) as List;
      } catch (_) {
        final step1 = raw.replaceAll("'", '"');
        final step2 = step1.replaceAllMapped(
            RegExp(r'([a-zA-Z0-9_]+):'), (m) => '"${m[1]}":');
        try {
          return jsonDecode(step2) as List;
        } catch (_) {
          
          // Merge stray comma-separated tokens that are not key:value pairs
          String mergeStrayTokens(String s) {
            final keyRegex = RegExp(r'"[a-zA-Z0-9_]+"\s*:');
            final matches = keyRegex.allMatches(s).toList();
            if (matches.length < 2) return s;
            final buffer = StringBuffer();
            int pos = 0;
            for (var i = 0; i < matches.length; i++) {
              final m = matches[i];
              if (i == 0) buffer.write(s.substring(0, m.start));
              final nextStart = (i + 1 < matches.length) ? matches[i + 1].start : s.length;
              final keyAndColon = s.substring(m.start, m.end);
              buffer.write(keyAndColon);
              final valueSeg = s.substring(m.end, nextStart);
              final quotedMatch = RegExp(r'^\s*"([^"]*)"').firstMatch(valueSeg);
              if (quotedMatch != null) {
                var rest = valueSeg.substring(quotedMatch.end);
                if (rest.trim().isNotEmpty) {
                  final extra = rest.replaceAll(RegExp(r'[,\s]+$'), '').trim();
                  final merged = quotedMatch[1];
                  final allExtra = extra.replaceAll(RegExp(r'^[,\s]*'), '').replaceAll(RegExp(r'[,\s]*$'), '');
                  final combined = allExtra.isNotEmpty ? '$merged, ${allExtra}' : merged;
                  buffer.write('"${combined!.replaceAll('"', '\\"')}"');
                } else {
                  buffer.write(valueSeg);
                }
              } else {
                // no initial quote; if segment contains commas and no colon, treat as single quoted value
                if (!valueSeg.contains(':') && valueSeg.contains(',')) {
                  final combined = valueSeg.replaceAll(RegExp(r'[,\s]+$'), '').trim();
                  buffer.write('"${combined.replaceAll('"', '\\"')}"');
                } else {
                  buffer.write(valueSeg);
                }
              }
              pos = nextStart;
            }
            if (pos < s.length) buffer.write(s.substring(pos));
            return buffer.toString();
          }

          final step3 = mergeStrayTokens(step2);
                // Insert missing commas between adjacent key:value pairs like
                // ..."value" "nextKey": -> ..."value", "nextKey":
                      final step3norm = step3.replaceAllMapped(
                          RegExp(r'"\s*"([a-zA-Z0-9_]+)"\s*:'),
                          (m) => '", "${m[1]}":');

                      String fixMeasuresSection(String s) {
                        int idx = 0;
                        while (true) {
                          final mIndex = s.indexOf('"measures"', idx);
                          if (mIndex == -1) break;
                          final colon = s.indexOf(':', mIndex);
                          if (colon == -1) break;
                          final braceStart = s.indexOf('{', colon);
                          if (braceStart == -1) break;
                          // find matching closing brace
                          int depth = 0;
                          int i = braceStart;
                          for (; i < s.length; i++) {
                            if (s[i] == '{') depth++;
                            else if (s[i] == '}') {
                              depth--;
                              if (depth == 0) break;
                            }
                          }
                          if (i >= s.length) break;
                          final braceEnd = i;
                          // detect if the object was wrapped in quotes
                          int preCharIndex = braceStart - 1;
                          bool wrapped = false;
                          if (preCharIndex >= 0 && s[preCharIndex] == '"') wrapped = true;
                          int postCharIndex = braceEnd + 1;
                          if (postCharIndex < s.length && s[postCharIndex] == '"') wrapped = wrapped && true;

                            var inner = s.substring(braceStart, braceEnd + 1);
                            // collapse any double double-quotes inside measures (e.g., 8.818"" -> 8.818")
                            inner = inner.replaceAll('""', '"');
                            // collapse runs of quotes immediately before comma/} into a single quote
                            inner = inner.replaceAll(RegExp(r'"+(?=\s*[,}])'), '"');
                            // normalize cases like :"1.0"" or :"1.0"", -> :"1.0"
                            inner = inner.replaceAllMapped(
                                RegExp(r'(:\s*")([^\"]*?)"+(\s*[,}])'),
                                (m) => ':"${m[2]}"${m[3]}');
                          // replace the original span
                          final before = s.substring(0, wrapped ? preCharIndex : braceStart);
                          final after = s.substring(wrapped ? postCharIndex + 1 : braceEnd + 1);
                          s = before + inner + after;
                          idx = before.length + inner.length;
                        }
                        return s;
                      }
                try {
                  final fixed = fixMeasuresSection(step3norm);
                  return jsonDecode(fixed) as List;
                } catch (e) {
                  // final fallback: quote remaining unquoted simple values
                  try{
                    final step4 = step3norm.replaceAllMapped(
                        RegExp(r':\s*([^\\"\\[\\{][^,\\}\]]*?)(?=\s*[,\\}])'),
                        (m) => ':"${m[1]!.trim()}"');
                    return jsonDecode(step4) as List;
                  }catch(e){
                  
                    log('---------0----${e.toString()}');
                    return [];
                  }
                }
        }
      }
    }
  }

  @override
  void initState() {
    _loadFavoriteMeals = ref
        .read(favoriteMealsProvider.notifier)
        .getAllFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allFavoriteMeals = ref.watch(favoriteMealsProvider);
    // for (var item in allFavoriteMeals) {
    //   var ingredient = item.mealIngredients;
    //   // var amount = ingredient['measures']['metric']['amount'];
    //   // var unitShort = ingredient['measures']['metric']['unitShort'];
    //   // var image = ingredient['image'];
    //   formattedIngredients.add(
    //     ingredient as List
    //     // {
    //     //   'amount' : amount,
    //     //   'unitShort' : unitShort,
    //     //   'image' : image
    //     // }
    //   );
    // }
    // var a = _decodeIngredients(
    //                         allFavoriteMeals[0].mealIngredients.toString());
    // log('-------------a6--$a');
    return FutureBuilder(
      future: _loadFavoriteMeals,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.lightGreen,
                  size: 50,
                ),
                const Text(
                  'Loading...',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: .max,
              crossAxisAlignment: .start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 12, top: 15),
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: GridView.builder(
                      itemCount: allFavoriteMeals.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 2,
                          ),
                      itemBuilder: (context, index) {
                        return MealDisplay(
                          mealName: allFavoriteMeals[index].mealName.toString(),
                          mealRating: allFavoriteMeals[index].mealRating
                              .toString(),
                          mealImage: allFavoriteMeals[index].mealImage
                              .toString(),
                          cookTime: allFavoriteMeals[index].cookTime.toString(),
                          mealId: allFavoriteMeals[index].mealId.toString(),
                          mealIngredients: _decodeIngredients(
                            allFavoriteMeals[index].mealIngredients.toString()),
                          mealInstructions: allFavoriteMeals[index]
                              .mealInstructions
                              .toString(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
