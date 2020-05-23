import 'package:covid/Repositories/covid_repositories.dart';
import 'package:covid/bloc/country/covi_country_bloc.dart';
import 'package:covid/bloc/covid_bloc.dart';
import 'package:covid/bloc/covid_countries_event.dart';
import 'package:covid/bloc/covid_global_state.dart';

import 'package:covid/widget/card_prevention.dart';
import 'package:covid/widget/mapScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_covid.dart';

class Prevention extends StatefulWidget {
  @override
  _PreventionState createState() => _PreventionState();
}

class _PreventionState extends State<Prevention> {
  bool isLoading = false;

  void _gotoDetailsPage(String name) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
              body: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Hero(
                    tag: 'hero detail',
                    child: Image.asset(name,fit: BoxFit.cover,),
                  ),
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<CovidBloc, CovidGlobalState>(
      listener: (context, state) {
        if (state is GlobalLoadingError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Container(
                  child: Text(
                '${state.error}',
                textAlign: TextAlign.center,
              )),
              backgroundColor: Theme.of(context).errorColor,
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is GlobalLoadingSuccess) {
          if (state.global == null) {
            Center(
              child: Text('no posts'),
            );
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<CovidBloc>(
                  create: (context) =>
                      CovidBloc(covidRepositories: CovidRepositories()),
                ),
                BlocProvider<CountryBloc>(
                  create: (context) =>
                      CountryBloc(covidRepositories: CovidRepositories()),
                )
              ],
              child: DashboardCovid(
                global: state.global,
              ),
            );
          }));
        }
      },
      child:
          BlocBuilder<CovidBloc, CovidGlobalState>(builder: (context, state) {
        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/BG_prevention.PNG",
                      ),
                      fit: BoxFit.cover)),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.03),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 40, bottom: 20),
                    child: Text(
                      "Les mesures de précaution 🚑🌡",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Center(
                    child: Wrap(
                      runSpacing: 5,
                      spacing: 5,
                      children: <Widget>[
                        GestureDetector(
                            child: Hero(
                              child: CardPrevention(
                                link: "assets/covid-imzge1.jpg",
                              ),
                              tag: 'hero1',
                            ),
                            onTap: () =>
                                _gotoDetailsPage("assets/covid-imzge1.jpg")),
                        GestureDetector(
                          onTap: () =>
                              _gotoDetailsPage("assets/covid-imzge2.jpg"),
                          child: Hero(
                            tag: 'hero2',
                            child: CardPrevention(
                              link: "assets/covid-imzge2.jpg",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, top: 20, bottom: 20),
                    child: Text(
                      "Consulter un medecin si vous avez les Symptôme\n 😓😷🤕🤧 ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Center(
                    child: Wrap(
                      runSpacing: 5,
                      spacing: 5,
                      children: <Widget>[
                        CardPrevention(
                          link: "assets/doctor.gif",
                        ),
                        CardPrevention(
                          link: "assets/doctordial_home.gif",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(1),
                          child: Icon(
                            Icons.phone,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        ),
                        Text(
                          "Appeler le ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          "1510 ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          "pour toute autre information ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              splashColor: Colors.green,
              onTap: () {
                BlocProvider.of<CovidBloc>(context)..add(FetchCovidGlobal());
                setState(() {
                  isLoading = true;
                });
                Future.delayed(Duration(seconds: 15), () {
                  setState(() {
                    isLoading = false;
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                            child: Text(
                          "Tu es fatigué d'attendre nor!!😂😂\nProbleme de réseau ou peut etre ta connexion est borlèè!!🤣🤣🤣",
                          textAlign: TextAlign.center,
                        )),
                        backgroundColor: Theme.of(context).errorColor,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                });
              },
              child: Card(
                color: Color(0xFFFCFCFC),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Statistic of the word',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      ),
                      isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              Icons.arrow_forward_ios,
                              color: Theme.of(context).primaryColor,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MapScreen(),
          ],
        ));
      }),
    ));
  }
}
