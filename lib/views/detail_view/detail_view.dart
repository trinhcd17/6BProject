import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:money_statistic/components/bottom_sheet.dart';
import 'package:money_statistic/components/rounded_button.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/models/transaction.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/transaction_service.dart';
import 'package:money_statistic/service/user_service.dart';
import 'package:money_statistic/views/add_view/controller.dart';
import 'package:money_statistic/views/detail_view/controller.dart';
import 'package:toast/toast.dart';

class DetailView extends StatefulWidget {
  final Transactions transactions;

  const DetailView({Key key, this.transactions}) : super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final DetailController detailController = Get.put(DetailController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDetailController();
    titleController.text = widget.transactions.title;
    priceController.text = widget.transactions.price.toString();
    dateTimeController.text =
        '${detailController.dateTime.day} Tháng ${detailController.dateTime.month} ${detailController.dateTime.year}';
  }

  void initDetailController() {
    detailController.changeDateTime(DateTime.now());
    detailController.changeEditStatus(false);
    detailController.listUsers = widget.transactions.userSpecial;
    detailController.changeSwitchStatus(widget.transactions.special);
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
          child: GetBuilder<DetailController>(builder: (_) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
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
                          enabled: _.isEditing,
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
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                if (_.isEditing) {
                                  showDatePicker(context);
                                }
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
                                  if (_.isEditing) {
                                    showDatePicker(context);
                                  }
                                },
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                              enabled: _.isEditing,
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
                                  if (_.isEditing) {
                                    detailController.changeSwitchStatus(status);
                                    if (status) {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              CustomBottomSheet(
                                                reverse: true,
                                              )).whenComplete(() {
                                        if (selectedUsers.isEmpty) {
                                          _.changeSwitchStatus(false);
                                        }
                                      });
                                    } else {
                                      _.listUsers = [];
                                    }
                                  }
                                }),
                          ],
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            for (var item in _.listUsers)
                              buildSpecialUserItem(_, item),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    width: screenSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButtonHalfSize(
                          title: _.isEditing ? 'Lưu' : 'Chỉnh sửa',
                          function: () async {
                            _.changeEditStatus(true);
                          },
                          loading: _.loading,
                          screenSize: screenSize,
                          backgroundColor:
                              _.isEditing ? Colors.blueAccent : kPrimaryColor,
                        ),
                        if (!_.isEditing)
                          RoundedButtonHalfSize(
                            title: 'Xoá',
                            function: () async {},
                            loading: _.loading,
                            screenSize: screenSize,
                            backgroundColor: Colors.red,
                          ),
                      ],
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

  Widget buildSpecialUserItem(DetailController _, String uid) {
    return FutureBuilder(
        future: UserService.getDisplayNameByUID(uid),
        builder: (context, snapshot) {
          return Container(
            height: 30,
            width: 100,
            margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: kPrimaryColorWithOpacity),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    snapshot.hasData ? snapshot.data['data'] : '...',
                    style: TextStyle(color: kPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_.isEditing)
                  InkWell(
                    onTap: () {
                      _.removeUser(uid);
                    },
                    child: Icon(
                      Icons.cancel_rounded,
                      size: 15,
                    ),
                  ),
              ],
            )),
          );
        });
  }

  Future _createFunc(DetailController _) async {
    if (_formKey.currentState.validate()) {
      detailController.isLoading(true);
      await TransactionService.addTransaction(
          titleController.text,
          detailController.dateTime,
          int.parse(priceController.text.toString()),
          _.switchStatus,
          selectedUsers);
      detailController.isLoading(false);
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
      detailController.changeDateTime(date);
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
