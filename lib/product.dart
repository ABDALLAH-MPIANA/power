
class Product{
  int _id;
  String _libelle;
  String _tva;
  String _ddi;
  String _position;
  String _date;
  String _unite;
  String _dci;
  String _dcl;

  Product(this._libelle,
          this._tva,this._ddi,
          this._position,
          this._date,
          this._unite,
          this._dci,
          this._dcl);

  Product.fromMap(dynamic obj){
    //this._id=obj['id'];
    
    this._libelle=  obj['libelle'].toString().toUpperCase();
    this._tva=      obj['tva'].toString().toUpperCase();
    this._ddi=      obj['ddi'].toString().toUpperCase();
    this._position= obj['position'].toString().toUpperCase();
    this._date=     obj['debut'].toString().toUpperCase();
    this._unite=    obj['unite'].toString().toUpperCase();
    this._dci=      obj['dci'].toString().toUpperCase();
    this._dcl=      obj['dcl'].toString().toUpperCase();

  }

  factory Product.fromJson( json){
    return Product(
                    json['libelle'] as String, 
                    json['tva'] as String,
                    json['ddi'] as String,
                    json['position'] as String,
                    json['debut'] as String,
                    json['unite'] as String,
                    json['dci'] as String,
                    json['dcl'] as String);
                    
  }

  String get libelle => _libelle;
  String get tva =>  _tva;
  String get ddi => _ddi ;
  String get positiontarifaire =>  _position;
  String get date => _date ;
  String get unite =>  _unite;
  String get dci => _dci ;
  String get dcl => _dcl;



  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    
    map["libelle"] = _libelle;
    map["tva"] = _tva;
    map["ddi"] = _ddi;
    map["position"] = _position;
    map["debut"] = _date;
    map["unite"] = _unite;
    map["dci"] = _dci;
    map["dcl"] = _dcl;
    
    return map;
  }
}