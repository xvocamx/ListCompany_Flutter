import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_listcompany/model/company.dart';
import 'package:http/http.dart' as http;

class NetWorkRequest {

  static int? pageNumber;
  numberPage(int page) {
    pageNumber = page;
    return pageNumber;
  }

  static String url = 'http://192.168.1.151/company/companyAll.php';

  //Function that converts a responese body a List<Company>
  List<Company> parseCompany(String responseBody) {
    final parsed = jsonDecode(utf8.decode(responseBody.codeUnits)).cast<Map<String, dynamic>>();
    return parsed.map<Company>((json) => Company.fromJson(json)).toList();
  }

  Future<List<Company>> fetchCompany() async {
    final response = await http.get(Uri.parse('$url?page=$pageNumber'));
    if (response.statusCode == 200) {
      //Use the compute function to run parseCompany in a separate isolate.
      return compute(parseCompany,response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Failed to load Company');
    }
  }





}
