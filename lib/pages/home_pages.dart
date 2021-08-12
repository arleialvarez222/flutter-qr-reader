import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/mapas_page.dart';

//import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

import 'package:qr_reader/widgets/custon_navigationbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation:0 ,
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: (){
              Provider.of<ScanListProvider>(context, listen: false)
              .borrarScan();
            }, 
          )
        ],
      ),
      body: _HomePageBody(),
     bottomNavigationBar: CustomNavigationBar(),
     floatingActionButton: ScanButton(),
     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   );
  }
}
class _HomePageBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final uiProvider = Provider.of<UiProvider>(context);

    final currenIndex = uiProvider.selectedMenuOpt;

    //TODO: temporal lerer bd
    //DBProvider.db.database;
    //final tempScan = new ScanModel( valor: 'http://google.com');
    //DBProvider.db.getScanById(2).then( print);
    
    //usar el provider

    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

    switch(currenIndex){

      case 0:
      scanListProvider.cargarScanTipo('geo');
      return MapasPage();

      case 1:
      scanListProvider.cargarScanTipo('http');
      return DireccionesPage();

      default:
      return MapasPage();
    }
 
    
  }
}