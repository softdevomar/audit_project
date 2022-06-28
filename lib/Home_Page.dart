
import 'package:audit_p/Provider/Provider_Helper.dart';
import 'package:audit_p/widget/form_Decoration.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart'as stt;
import 'package:provider/provider.dart';
class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final _formKey=GlobalKey<FormState>();

  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  String _lastWords='';
  @override
  void initState() {
    super.initState();

    var _speech = stt.SpeechToText();
    _custominitState();
  }
  void onListen() async{
    if(!_speechEnabled){
      bool available=await _speech.initialize(
        onStatus: (val)=>print('onStatus;$val'),
        onError: (val)=>print('onError$val')
      );
      if(available){
        setState((){
          _speechEnabled=true;
        });
        _speech.listen(
          onResult: (val)=>setState((){
            _lastWords=val.recognizedWords;
          }),
        );

      }

    }else{
      setState(()=>_speechEnabled=false);
      _speech.stop();
    }

  }
  List<Map<String,dynamic>> _dataList=[];
  int count=0;
  _custominitState()async{
    var list=await SQLHealper.getAlldata();
    setState((){
      count++;
      _dataList=list;
    });

  }

  @override
  Widget build(BuildContext context) {
     SQLHealper info_providerdata = Provider.of<SQLHealper>(context);
    return Scaffold(
      appBar:  AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){


            },
            icon: Icon(Icons.arrow_upward_rounded),
          ),
        ],
        title: Text("Market Survey"),
      ),
      body: _dataList.isNotEmpty ?GridView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 100,
            mainAxisSpacing: 10,
            childAspectRatio: 50,
          ),
          itemCount:_dataList.length,
          itemBuilder: (context,index){
            return  Gridview(index,info_providerdata);
          }):Center(child: Text('No Data Found Yet !!',style: TextStyle
        (fontSize: 20,color: Colors.red),),),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _modalBottomSheetMenu(info_providerdata,null,null,null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Widget Gridview(int index,SQLHealper providerdata){
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
                color: Colors.orange[300],
            ),
            child: ListTile(
              title: Text(_dataList[index]['ChamberName'].toString()),
              subtitle: Text(_dataList[index]['PartyName'].toString()),
              trailing: Wrap(
                children: [
                  InkWell(
                    onTap: (){
                      _modalBottomSheetMenu(
                        providerdata,
                        _dataList[index]['id'],
                        _dataList[index]['ChamberName'].toString(),
                        _dataList[index]['PartyName'].toString(),
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: (){
                      providerdata.deletData(_dataList[index]["id"]);
                      _custominitState();
                    },
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),

      ),
    );
  }

  void _modalBottomSheetMenu(SQLHealper provider,int ?id,String ?chamber,String ?party){

    Size size=MediaQuery.of(context).size;
      showModalBottomSheet(
          context: context,
          elevation: 100,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
            ),
          ),
          builder: (contex)=>SingleChildScrollView(
            child: Container(
                child: Padding(padding: MediaQuery.of(context).viewInsets,
                  child: Padding(
                    padding:EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height:size.width*0.05),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("$_lastWords"),

                                      OutlinedButton(
                                        // onPressed: onListen,
                                        onPressed: ()=>showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title:  Text('Listening...'),
                                            content: IconButton(onPressed: (){
                                              onListen();
                                              Navigator.of(context).pop(contex);
                                              _speech;

                                            }, icon:Icon(Icons.mic)),
                                            
                                          ),
                                        ),
                                        child: Icon(Icons.mic),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:size.width*0.05),
                                  _textFieldBuilder('Chamber Name',provider),
                                  SizedBox(height:size.width*0.03),
                                  _textFieldBuilder('Dr / Party Name',provider),
                                  SizedBox(height:size.width*0.03),
                                  _textFieldBuilder('Mobile',provider),
                                   SizedBox(height:size.width*0.03),
                                  _textFieldBuilder('Address',provider),
                                  SizedBox(height:size.width*0.03),
                                  _textFieldBuilder('CATG',provider),
                                   SizedBox(height:size.width*0.03),
                                  _textFieldBuilder('Degree',provider),
                                  SizedBox(height:size.width*0.03),
                                  _textFieldBuilder('Bus',provider),
                                  SizedBox(height:size.width*0.03),
                                  _textFieldBuilder('Remark',provider),
                                  InkWell(
                                      onTap: (){
                                         if(id==null) {
                                           provider.insertData(
                                               context, provider,
                                               provider.info_model).then((
                                               value) => {
                                             if(value != -1){
                                               ScaffoldMessenger.of(context)
                                                   .showSnackBar(
                                                 SnackBar(content: Text(
                                                     "Successfully data insert")),
                                               ),
                                             } else
                                               {
                                                 ScaffoldMessenger.of(context)
                                                     .showSnackBar(
                                                     SnackBar(content: Text(
                                                         "Data inser field"))
                                                 ),
                                               }
                                           }
                                           );
                                         }else{
                                           provider.updatetData(context, provider, provider.info_model, id);
                                         }
                                        Navigator.of(context).pop(contex);
                                         _custominitState();
                                      },
                                    child: Padding(padding: EdgeInsets.all(10),
                                      child:Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child:id==null? Text("CREATE NEW",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),)
                                            :Text("Update date",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ),
                                ],
                              )),
                        ],
                      ),
                  ),

                ),
              ),
          )

      );
  }


  Widget _textFieldBuilder(String ?hintTxt,SQLHealper provider_data ){
    Size size=MediaQuery.of(context).size;
    return  TextFormField(

          cursorColor: Colors.black12,
          keyboardType: hintTxt=='Mobile'?TextInputType.text
              : hintTxt=='Faculty ID'?TextInputType.phone
              :TextInputType.text,
          decoration: FormDecoration.copyWith(
            labelText: hintTxt,
            labelStyle: TextStyle(
                fontSize: size.height*0.020,
            ),
          ),
         onTap: (){
            if(hintTxt=='Chamber Name'){

            }
         },

          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Fill All filled';
            }
            return null;
          },
          onChanged: (value){
            setState(() {
              hintTxt=='Chamber Name'?provider_data.info_model.ChamberName=value:
              hintTxt=='Dr / Party Name'?provider_data.info_model.PartyName=value:
              hintTxt=='Mobile'?provider_data.info_model.Mobile=value:
              hintTxt=='Address'?provider_data.info_model.Address=value:
              hintTxt=='CATG'?provider_data.info_model.Catg=value:
              hintTxt=='Degree'?provider_data.info_model.Degree=value:
              hintTxt=='Bus'?provider_data.info_model.Bus=value:
              hintTxt=='Remark'?provider_data.info_model.Remark=value
                  :provider_data.info_model.Remark=value;
            });
          },
        );

  }
}
