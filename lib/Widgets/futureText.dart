import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class FutureText extends StatelessWidget {
  FutureText({required this.name});
  String name;
  Future<String> getTranslate(String name) async {
    final trans = await name.translate(from: "auto", to: "ta");
    return trans.text;
  }

  Map<String, String> tamilToThanglishMap = {
    // Vowels
    'அ': 'a', 'ஆ': 'aa', 'இ': 'i', 'ஈ': 'ii', 'உ': 'u', 'ஊ': 'uu',
    'எ': 'e', 'ஏ': 'ee', 'ஐ': 'ai', 'ஒ': 'o', 'ஓ': 'oo', 'ஔ': 'au',

    // Consonants
    'க': 'ka', 'ங': 'nga', 'ச': 'cha', 'ஞ': 'nya', 'ட': 'ta', 'ண': 'na',
    'த': 'tha', 'ந': 'na', 'ப': 'pa', 'ம': 'ma', 'ய': 'ya', 'ர': 'ra',
    'ல': 'la', 'வ': 'va', 'ழ': 'zha', 'ள': 'la', 'ற': 'rra', 'ன': 'na',
    'ஜ': 'ja', 'ஷ': 'sha', 'ஸ': 'sa', 'ஹ': 'ha', 'க்ஷ': 'ksha', 'ஶ': 'sha',

    // Consonants with vowel signs
    'கா': 'kaa', 'கி': 'ki', 'கீ': 'kii', 'கு': 'ku', 'கூ': 'kuu', 'கெ': 'ke',
    'கே': 'kee', 'கை': 'kai',
    'கொ': 'ko', 'கோ': 'koo', 'கௌ': 'kau',
    'சா': 'chaa', 'சி': 'chi', 'சீ': 'chii', 'சு': 'chu', 'சூ': 'chuu',
    'செ': 'che', 'சே': 'chee', 'சை': 'chai',
    'சொ': 'cho', 'சோ': 'choo', 'சௌ': 'chau',
    'டா': 'taa', 'டி': 'ti', 'டீ': 'tii', 'டு': 'tu', 'டூ': 'tuu', 'டெ': 'te',
    'டே': 'tee', 'டை': 'tai',
    'டொ': 'to', 'டோ': 'too', 'டௌ': 'tau',
    'தா': 'thaa', 'தி': 'thi', 'தீ': 'thii', 'து': 'thu', 'தூ': 'thuu',
    'தெ': 'the', 'தே': 'thee', 'தை': 'thai',
    'தொ': 'tho', 'தோ': 'thoo', 'தௌ': 'thau',
    'பா': 'paa', 'பி': 'pi', 'பீ': 'pii', 'பு': 'pu', 'பூ': 'puu', 'பெ': 'pe',
    'பே': 'pee', 'பை': 'pai',
    'பொ': 'po', 'போ': 'poo', 'பௌ': 'pau',
    'மா': 'maa', 'மி': 'mi', 'மீ': 'mii', 'மு': 'mu', 'மூ': 'muu', 'மெ': 'me',
    'மே': 'mee', 'மை': 'mai',
    'மொ': 'mo', 'மோ': 'moo', 'மௌ': 'mau',

    // More consonants with vowel signs
    'யா': 'yaa', 'யி': 'yi', 'யீ': 'yii', 'யு': 'yu', 'யூ': 'yuu', 'யெ': 'ye',
    'யே': 'yee', 'யை': 'yai',
    'யொ': 'yo', 'யோ': 'yoo', 'யௌ': 'yau',
    'ரா': 'raa', 'ரி': 'ri', 'ரீ': 'rii', 'ரு': 'ru', 'ரூ': 'ruu', 'ரெ': 're',
    'ரே': 'ree', 'ரை': 'rai',
    'ரொ': 'ro', 'ரோ': 'roo', 'ரௌ': 'rau',
    'லா': 'laa', 'லி': 'li', 'லீ': 'lii', 'லு': 'lu', 'லூ': 'luu', 'லெ': 'le',
    'லே': 'lee', 'லை': 'lai',
    'லொ': 'lo', 'லோ': 'loo', 'லௌ': 'lau',
    'வா': 'vaa', 'வி': 'vi', 'வீ': 'vii', 'வு': 'vu', 'வூ': 'vuu', 'வெ': 've',
    'வே': 'vee', 'வை': 'vai',
    'வொ': 'vo', 'வோ': 'voo', 'வௌ': 'vau',
    'ழா': 'zhaa', 'ழி': 'zhi', 'ழீ': 'zhii', 'ழு': 'zhu', 'ழூ': 'zhuu',
    'ழெ': 'zhe', 'ழே': 'zhee', 'ழை': 'zhai',
    'ழொ': 'zho', 'ழோ': 'zhoo', 'ழௌ': 'zhau',
    'ளா': 'laa', 'ளி': 'li', 'ளீ': 'lii', 'ளு': 'lu', 'ளூ': 'luu', 'ளெ': 'le',
    'ளே': 'lee', 'ளை': 'lai',
    'ளொ': 'lo', 'ளோ': 'loo', 'ளௌ': 'lau',
    'றா': 'rraa', 'றி': 'rri', 'றீ': 'rrii', 'று': 'rru', 'றூ': 'rruu',
    'றெ': 'rre', 'றே': 'rree', 'றை': 'rrai',
    'றொ': 'rro', 'றோ': 'rroo', 'றௌ': 'rrau',
    'னா': 'naa', 'னி': 'ni', 'னீ': 'nii', 'னு': 'nu', 'னூ': 'nuu', 'னெ': 'ne',
    'னே': 'nee', 'னை': 'nai',
    'னொ': 'no', 'னோ': 'noo', 'னௌ': 'nau',

    // Compound characters (Consonant + Vowel signs)
    'க': 'k', 'க்': 'k', 'கா': 'kaa', 'கி': 'ki', 'கீ': 'kii', 'கு': 'ku',
    'கூ': 'kuu', 'கெ': 'ke', 'கே': 'kee', 'கை': 'kai',
    'கொ': 'ko', 'கோ': 'koo', 'கௌ': 'kau',
    'ச': 'ch', 'ச்': 'ch', 'சா': 'chaa', 'சி': 'chi', 'சீ': 'chii', 'சு': 'chu',
    'சூ': 'chuu', 'செ': 'che', 'சே': 'chee', 'சை': 'chai',
    'சொ': 'cho', 'சோ': 'choo', 'சௌ': 'chau',
    'ட': 't', 'ட்': 't', 'டா': 'taa', 'டி': 'ti', 'டீ': 'tii', 'டு': 'tu',
    'டூ': 'tuu', 'டெ': 'te', 'டே': 'tee', 'டை': 'tai',
    'டொ': 'to', 'டோ': 'too', 'டௌ': 'tau',
    'த': 'th', 'த்': 'th', 'தா': 'thaa', 'தி': 'thi', 'தீ': 'thii', 'து': 'thu',
    'தூ': 'thuu', 'தெ': 'the', 'தே': 'thee', 'தை': 'thai',
    'தொ': 'tho', 'தோ': 'thoo', 'தௌ': 'thau',
    'ப': 'p', 'ப்': 'p', 'பா': 'paa', 'பி': 'pi', 'பீ': 'pii', 'பு': 'pu',
    'பூ': 'puu', 'பெ': 'pe', 'பே': 'pee', 'பை': 'pai',
    'பொ': 'po', 'போ': 'poo', 'பௌ': 'pau',
    'ம': 'm', 'ம்': 'm', 'மா': 'maa', 'மி': 'mi', 'மீ': 'mii', 'மு': 'mu',
    'மூ': 'muu', 'மெ': 'me', 'மே': 'mee', 'மை': 'mai',
    'மொ': 'mo', 'மோ': 'moo', 'மௌ': 'mau'
  };

  void trans(String name) {
    for (int i = 0; i < name.length; i++) {
      print("a");
      print(tamilToThanglishMap[name[i]]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getTranslate(name), // Your future
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // Checking the state of the snapshot
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display a loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Display an error message
        } else if (snapshot.hasData) {
          return Text(snapshot.data!); // Display the data
        } else {
          return Text('No data'); // Handle the case where no data is returned
        }
      },
    );
  }
}
