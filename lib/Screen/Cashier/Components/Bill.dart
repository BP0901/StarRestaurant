import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class BillPrint extends StatefulWidget {
  final DocumentSnapshot? bill;
  final String tableName;
  final AsyncSnapshot<QuerySnapshot<Object?>> billDetail;
  const BillPrint(
      {Key? key,
      required this.bill,
      required this.tableName,
      required this.billDetail})
      : super(key: key);
  @override
  State<BillPrint> createState() => _BillPrintState();
}

class _BillPrintState extends State<BillPrint> {
  final pdf = pw.Document();
  // var name;
  // var subject1;
  // var subject2;
  // var subject3;

  var marks;
  void initState() {
    setState(() {
      // name = widget.docid?.get('name');
      // subject1 = widget.docid?.get('Maths');
      // subject2 = widget.docid?.get('Science');
      // subject3 = widget.docid?.get('History');

      // marks = int.parse(subject1) + int.parse(subject2) + int.parse(subject3);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      // maxPageWidth: 1000,
      // useActions: false,
      // canChangePageFormat: true,
      canChangeOrientation: false,
      // pageFormats:pageformat,
      canDebug: false,

      build: (format) => generateDocument(
        format,
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();
    final image = await imageFromAssetBundle('assets/images/logo.png');

    DateTime requestedPayTime = widget.bill!.get("date").toDate();
    String formattedDate =
        DateFormat('dd-MM-yyyy – kk:mm').format(requestedPayTime);

    doc.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font2,
          ),
        ),
        build: (context) {
          return pw.Center(
              child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Flexible(
                child: pw.Image(image, height: 100),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Center(
                child: pw.Text(
                  'Star Restaurant',
                  style: const pw.TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Divider(),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      widget.tableName.toString(),
                      style: const pw.TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    pw.Text(
                      formattedDate,
                      style: const pw.TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ]),
              pw.SizedBox(
                height: 20,
              ),
              pw.Divider(),
              pw.SizedBox(
                width: 1000,
                child: pw.ListView.builder(
                  itemCount: widget.billDetail.data!.size,
                  itemBuilder: (context, index) {
                    String name =
                        widget.billDetail.data!.docs[index].get("foodName");

                    int amount =
                        widget.billDetail.data!.docs[index].get("amount");
                    int price =
                        widget.billDetail.data!.docs[index].get("price");
                    int total =
                        widget.billDetail.data!.docs[index].get("amount") *
                            widget.billDetail.data!.docs[index].get("price");
                    return pw.Row(
                      children: [
                        pw.SizedBox(
                          height: 30,
                        ),
                        pw.Column(children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                name,
                                style: const pw.TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              pw.Text(""),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                amount.toString(),
                                style: const pw.TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              pw.Text(
                                " X ",
                                style: const pw.TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              pw.Text(
                                price.toString().toVND(),
                                style: const pw.TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              pw.Text(
                                " = ",
                                style: const pw.TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              pw.Text(
                                total.toString().toVND(),
                                style: const pw.TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ]),
                        pw.SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  },
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Divider(),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Tổng",
                      style: const pw.TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    pw.Text(
                      widget.bill!.get("total").toString().toVND(),
                      style: const pw.TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ]),
            ],
          ));
        },
      ),
    );

    return doc.save();
  }
}
