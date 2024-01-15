import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/carWidget.dart';
import '../widgets/bookCar.dart';
import '../constants/data.dart';


class AvailableCars extends StatefulWidget {
  const AvailableCars({super.key});

  @override
  State<AvailableCars> createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  
  List<Filter> filters = getFilterList();
  late Filter selectedFilter;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedFilter = filters[0];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border.all(
                      color: (Colors.grey[300])!,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                    size: 28,
                  )
                ),
              ),
               const SizedBox(
                height: 16,
              ),

              Text(
                "Available Cars (" + getCarList().length.toString() + ")",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 16,
              ),
              

              Expanded(
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  //HAUTEUR :
                  childAspectRatio: 1 / 1.7,
                  //LARGEUR 2 VOITURES PAR LIGNE
                  crossAxisCount:2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 15,
                  children: getCarList().map((item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookCar(car: item)),
                        );
                      },
                      child: buildCar(item, 0));
                  }).toList(),
                ),
              ),

              ],
          ))),
          bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            buildFilterIcon(),
            Row(
              children: buildFilters(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget buildFilterIcon(){
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  List<Widget> buildFilters(){
    List<Widget> list = [];
    for (var i = 0; i < filters.length; i++) {
      list.add(buildFilter(filters[i]));
    }
    return list;
  }

  Widget buildFilter(Filter filter){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 16),
        child: Text(
          filter.name,
          style: TextStyle(
            color: selectedFilter == filter ? kPrimaryColor : Colors.grey[300],
            fontSize: 15,
            fontWeight: selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}