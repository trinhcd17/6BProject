import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_statistic/components/bottom_sheet.dart';
import 'package:money_statistic/components/rounded_button.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/transaction_service.dart';
import 'package:money_statistic/service/user_service.dart';
import 'package:money_statistic/views/add_view/controller.dart';
import 'package:toast/toast.dart';

class AddView extends StatefulWidget {
  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final AddController addController = Get.put(AddController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addController.changeDateTime(DateTime.now());
    dateTimeController.text =
        '${addController.dateTime.day} Tháng ${addController.dateTime.month} ${addController.dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(screenSize),
      body: Theme(
        data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: GetBuilder<AddController>(builder: (_) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nội dung',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Nội dung không được để trống';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Ngày',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        GetBuilder<AddController>(builder: (__) {
                          dateTimeController.text =
                              '${_.dateTime.day} Tháng ${_.dateTime.month} ${_.dateTime.year}';
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDatePicker(context);
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: dateTimeController,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 10,
                                child: InkWell(
                                  onTap: () {
                                    showDatePicker(context);
                                  },
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    color: kPrimaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Số tiền',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Stack(
                          children: [
                            TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Số tiền không được để trống';
                                } else if (!value.isNumericOnly) {
                                  return 'Vui lòng nhập số';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Positioned(
                              top: 15,
                              right: 10,
                              child: Text(
                                'đ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Khoản chi đặc biệt',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Switch.adaptive(
                                activeColor: kPrimaryColor,
                                value: _.switchStatus,
                                onChanged: (status) {
                                  addController.changeSwitchStatus(status);
                                  if (status) {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => CustomBottomSheet(
                                              reverse: true,
                                            )).whenComplete(() {
                                      if (selectedUsers.isEmpty) {
                                        _.changeSwitchStatus(false);
                                      }
                                    });
                                  }
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: RoundedButton(
                      title: 'Tạo',
                      function: () async {
                        await _createFunc(_);
                      },
                      loading: _.loading,
                      screenSize: screenSize,
                      backgroundColor: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future _createFunc(AddController _) async {
    if (_formKey.currentState.validate()) {
      addController.isLoading(true);
      await TransactionService.addTransaction(
          titleController.text,
          addController.dateTime,
          int.parse(priceController.text.toString()),
          _.switchStatus,
          selectedUsers);
      addController.isLoading(false);
      showToast('Update thành công!');
      _.changeSwitchStatus(false);
      clearTextField();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // addController.dispose();
  }

  void clearTextField() {
    titleController.clear();
    priceController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 1, 1),
        maxTime: DateTime.now(), onConfirm: (DateTime date) {
      addController.changeDateTime(date);
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  PreferredSize buildAppBar(Size screenSize) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: SafeArea(
        child: Stack(
          children: [
            buildPopButton(),
            Container(
              height: 50,
              width: screenSize.width,
              child: Center(
                  child: Text(
                'Phiếu chi',
                style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPopButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(left: 30.0),
        padding: EdgeInsets.only(left: 7.0),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 1),
                  spreadRadius: 0.1,
                  blurRadius: 10)
            ]),
        child: Icon(
          Icons.arrow_back_ios,
          color: kSecondaryColor,
        ),
      ),
    );
  }

  void showToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
