import 'dart:convert';
import 'dart:ui';
import 'package:dartxero/MiFramework/MiAcciones.dart';
import 'package:dartxero/MiFramework/MiVariablesGlobales.dart';
import 'package:dartxero/MiFramework/VentanasMensajes/MensajesSys.dart';
import 'package:dartxero/MiFramework/miAccionesGlobales.dart';
import 'package:dartxero/MiModel/BusquedaModel.dart';
import 'package:dartxero/MiModel/GridInicioModel.dart';
import 'package:dartxero/MiPantallas/Busqueda/BusquedaDetalle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GridInicio extends StatefulWidget {
  @override
  _GridInicioState createState() => _GridInicioState();
}

class _GridInicioState extends State<GridInicio> {
  static const _pageSize = 20;

  final PagingController _pagingController =
      PagingController<int, BusquedaModel>(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      } else {
        if (status == PagingStatus.noItemsFound) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.close,
                          ),
                          backgroundColor: Colors.red,
                          radius: 15,
                        ),
                      ),
                    ),
                    Container(
                      //width: double.maxFinite,
                      height: 200,
                      child: Column(
                        children: [
                          TipoIcon(1),
                          SizedBox(
                            height: 5,
                          ),
                          TipoMsj(1),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'No hay Menu para Mostrarte.',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: RaisedButton(
                            child: Text("Reitentar"),
                            onPressed: () =>
                                _pagingController.retryLastFailedRequest(),
                          )),
                        ],
                      ),
                    ),
                  ],
                ));
              });
        }
      }
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await ListViewMenu(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  CharacterListItem({BusquedaModel character, int i}) {
    return RaisedButton(
      child: Container(
        margin: EdgeInsets.all(0),
        //decoration: BoxDecoration(border: Border.all(color: ColorLineas, width: 0.5,),color: ColorFondo,),
        child: Column(
          children: [
            Container(
              child: Image(
                  height: 130.0,
                  width: 210.0,
                  image: Imagen(character.menufoto)),
            ),
            Container(
              child: Text(
                character.menuNombre ?? '',
                style: character.menuNombre.length >= 20 ? TextStyle(fontSize: 10.0) : TextStyle(fontSize: 15.0),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(
                '\$ ${character.Precio ?? ''}0',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorLabel),
              ),
              alignment: Alignment.centerLeft,
            )
          ],
        ),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BusquedaDetalle(Busqueda: character)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, BusquedaModel>(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      pagingController: _pagingController,
      showNewPageErrorIndicatorAsGridChild: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      builderDelegate: PagedChildBuilderDelegate<BusquedaModel>(
          itemBuilder: (context, item, index) {
        return CharacterListItem(character: item, i: index);
      }),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
/*
class GridHome extends StatefulWidget {
  @override
  _GridHomeState createState() => _GridHomeState();
}

class _GridHomeState extends State<GridHome> {
  static const int _COUNT = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Pagination(
        pageBuilder: (currentListSize) => ListViewMenu(currentListSize + 1, _COUNT),
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (index, item) {
          _GridView(item);
        },
        //itemBuilder: (item) => ListTile(title: Text(item)),
      ),
    );
  }

  _GridView(GridInicioModel Grid){
    return Container(child: Text(Grid.menuNombre),padding: EdgeInsets.all(5.0),);
  }

}
*/

Future<List<BusquedaModel>> ListViewMenu(int Offset, int Fetch) async {
  //final repose = await get("${sURL}Menu/MenuInicio/${Offset}/${Fetch}");
  final repose =
      await get(CadenaConexion("Menu/MenuInicio/${Offset}/${Fetch}"));
  if (repose.statusCode == 200 || repose.statusCode == 201) {
    List jsonResponse = json.decode(repose.body);
    return jsonResponse.map((job) => BusquedaModel.fromJson(job)).toList();
  } else {
    throw Exception("Fallo!");
  }
}
