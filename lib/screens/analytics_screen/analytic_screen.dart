// analytics_simple_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimpleAnalyticsController extends GetxController {
  var data = {}.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> loadExample() async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
        "https://play.im.dhis2.org/dev/api/analytics.json?"
        "dimension=dx:Uvn6LCg7dVU;OdiHJayrsKo"
        "&dimension=pe:LAST_4_QUARTERS"
        "&dimension=ou:O6uvpzGd5pu;fdc6uOvgoji"
        "&outputIdScheme=NAME"
      );

      final res = await http.get(url);
      if (res.statusCode == 200) {
        data.value = json.decode(res.body);
        Get.snackbar("Success", "Data loaded successfully!");
      } else {
        error.value = "Error ${res.statusCode}";
      }
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }
}

class SimpleAnalyticsPage extends StatelessWidget {
  const SimpleAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SimpleAnalyticsController());

    return Scaffold(
      appBar: AppBar(title: const Text("CreateB - Simple Analytics")),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: c.loadExample,
              child: const Text("Load ANC Coverage Data"),
            ),
            if (c.isLoading.value) const CircularProgressIndicator(),
            if (c.error.isNotEmpty) Text(c.error.value, style: const TextStyle(color: Colors.red)),
            
            Expanded(
              child: c.data.isEmpty 
                ? const Center(child: Text("Press button to load data"))
                : SingleChildScrollView(child: Text(c.data.toString())),
            )
          ],
        ),
      )),
    );
  }
}