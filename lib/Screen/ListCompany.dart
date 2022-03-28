import 'package:flutter/material.dart';
import 'package:flutter_listcompany/Screen/DetailComany.dart';
import 'package:flutter_listcompany/network/network_request.dart';
import '../model/company.dart';

class ListViewCompanyPage extends StatefulWidget {
  const ListViewCompanyPage({Key? key}) : super(key: key);

  @override
  State<ListViewCompanyPage> createState() => _ListViewCompanyPageState();
}

class _ListViewCompanyPageState extends State<ListViewCompanyPage> {
  final NetWorkRequest netWorkRequest = NetWorkRequest();
  List<Company> listCompany = <Company>[];
  List<Company> companyDisplay = <Company>[];
  int page = 1;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    netWorkRequest.numberPage(page);
    setState(() {
      isLoad = true;
    });
    netWorkRequest.fetchCompany().then((dataFromSever) {
      setState(() {
        listCompany.addAll(dataFromSever);
        companyDisplay = listCompany;
      });
    });
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('List Company')),
      ),
      body: isLoad == false
          ? ListView.builder(
              itemCount: companyDisplay.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return index == 0 ? _searchView() : _listItem(index - 1);
              })
          : const Center(child: CircularProgressIndicator()),
    );
  }

  _searchView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Mã số thuế, Tên công ty...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
            ),
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                companyDisplay = listCompany
                    .where((data) => (data.ma_so_thue
                            .toLowerCase()
                            .contains(text.toLowerCase()) ||
                        data.company_name
                            .toLowerCase()
                            .contains(text.toLowerCase())))
                    .toList();
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: const Icon(Icons.navigate_before),
              onPressed: () {
                if (page > 1) {
                  page--;
                  netWorkRequest.numberPage(page);
                  setState(() {
                    isLoad = true;
                    netWorkRequest.fetchCompany().then((dataFromSever) {
                      setState(() {
                        listCompany = dataFromSever;
                        companyDisplay = listCompany;
                        isLoad = false;
                      });
                    });
                  });
                } else {
                  final scaffold = ScaffoldMessenger.of(context);
                  scaffold.showSnackBar(SnackBar(
                    content: const Text("Đang ở trang đầu tiên"),
                    action: SnackBarAction(
                        label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
                  ));
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue),
                ),
              ),
              child: Text('$page'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: const Icon(Icons.navigate_next),
              onPressed: () {
                page++;
                netWorkRequest.numberPage(page);
                setState(() {
                  isLoad = true;
                  netWorkRequest.fetchCompany().then((dataFromSever) {
                    setState(() {
                      listCompany = dataFromSever;
                      companyDisplay = listCompany;
                      isLoad = false;
                    });
                  });
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  _listItem(index) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                elevation: 16,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 32, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mã số thuế: " + companyDisplay[index].ma_so_thue,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        companyDisplay[index].company_name,
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        "Địa chỉ: " + companyDisplay[index].company_address,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DetailCompany(company: companyDisplay[index]))),
        ),
      ],
    );
  }
}
