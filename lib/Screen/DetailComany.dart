import 'package:flutter/material.dart';
import 'package:flutter_listcompany/model/company.dart';
import 'package:url_launcher/url_launcher.dart';



class DetailCompany extends StatelessWidget {
  const DetailCompany({Key? key,required this.company}) : super(key: key);
  final Company company;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company.ma_so_thue.toString()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            child: Column(
              children: <Widget>[
                ListTile(
                    title: Text("Mã số thuế: " + company.ma_so_thue.toString())),
                ListTile(
                  title: Text("Tên công ty: " + company.company_name),
                ),
                ListTile(
                  title:
                  Text("Người đại diện: " + company.representative),
                ),
                ListTile(
                  title: Text("Địa chỉ: " + company.company_address),
                ),
                ListTile(
                  title: Text(company.company_phone == null
                      ? "Số điện thoại: Không có"
                      : "Số điện thoại: " + company.company_phone!),
                ),
                ListTile(
                  title: Text(company.managed_by == null
                      ? "Quản lý bởi: Không có"
                      : "Quản lý bởi: " + company.managed_by!),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: const Text('Call'),
                    onPressed: () {
                      //direct phone call
                      if (company.company_phone != null) {
                        launch(
                            'tel:${company.company_phone.toString()}');
                      } else {
                        return showToast(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: const Text("Không có số điện thoại"),
      action: SnackBarAction(
          label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ));
  }

}

