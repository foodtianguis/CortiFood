
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

TextEditingController txtRestNombre = new TextEditingController();
TextEditingController txtRestDescripcion = new TextEditingController();
TextEditingController txtRestTelefono = new TextEditingController(text: MskRestTelefono.text);
TextEditingController txtRest = new TextEditingController();

MaskedTextController MskRestTelefono = new MaskedTextController(mask: '000 000 0000');