import 'dart:math';

import 'package:flutter/material.dart';
import '../ui/utill/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  String _enteredCity;
  Future _goToNextScreen(BuildContext context)async{
    Map results=await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
      return new ChangeCity();
    }));

    if (results!=null&&results.containsKey('enter')){
      _enteredCity=results['enter'];
    }
  }

  void showData() async {
    Map _data = await getWeather(util.apiId, util.defaultCity);
    print(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Weather'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed: (){_goToNextScreen(context);})
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/umperella.jpg",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
            child: new Text(
              "${_enteredCity==null?util.defaultCity:_enteredCity}",
             // "cairo",
              style: TextStyle(
                  fontSize: 21.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),

          // container of weather data
          new Container(
            child: UpdateTempWidget("${_enteredCity==null?util.defaultCity:_enteredCity}"),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget UpdateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.apiId,  city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 320.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top:25.0),
                      child: new Text(content['main']['temp'].toString()+" C",
                      style:  tempstyle(),),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity : ${content['main']['humidity'].toString()}\n"
                            "Min : ${content['main']['temp_max'].toString()} C\n"
                            "Max : ${content['main']['temp_min'].toString()} C\n",
                        style: extraStyle(),
                      ),
                    ),

                  )
                ],
              ),
            );
          }else{
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change City"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',width: 490.0,height: 1200.0,fit: BoxFit.fill,),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City'
                  ),
                  controller: _cityController,
                  keyboardType: TextInputType.text,
                ),
              ),

              new ListTile(
                title: new FlatButton(onPressed: (){
                  Navigator.pop(context,{
                    'enter':_cityController.text
                  });
                },
                  child: new Text(
                    'Get Weather'),
                  textColor: Colors.white70,
                  color: Colors.red,
                ),
              )

            ],
          )

        ],
      ),
    );
  }
}

TextStyle extraStyle(){
  return new TextStyle(
      fontSize: 18.7,
      color: Colors.white,
      fontStyle: FontStyle.normal);
}

TextStyle tempstyle() {
  return new TextStyle(
      fontSize: 49.7,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal);
}
