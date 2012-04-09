package Geo::IP::Record;

use Geo::IP;    #

use vars qw/$pp/;


  use strict;

# here are the missing functions if the C API is used
  sub latitude {
    my $gir = shift;
    return sprintf( "%.4f", $gir->_latitude );
  }

  sub longitude {
    my $gir = shift;
    return sprintf( "%.4f", $gir->_longitude );
  }

BEGIN {
 $pp = !defined(&Geo::IP::Record::city)
  || $Geo::IP::GEOIP_PP_ONLY;
}

eval <<'__PP__' if $pp;

for ( qw: country_code    country_code3  country_name
          region          region_name    city
          postal_code     dma_code       area_code 
          continent_code  metro_code                      : ) {

  no strict   qw/ refs /;
  no warnings qw/ redefine /;
  my $m = $_; # looks bogus, but it is not! it is a copy not a alias
  *$_ = sub { $_[0]->{$m} };
}

# for the case warnings are globaly enabled with perl -w and the CAPI is absent
no warnings qw/ redefine /;

sub longitude {sprintf('%.4f', $_[0]->{longitude})}
sub latitude  {sprintf('%.4f', $_[0]->{latitude})}

{
  my $TIME_ZONE;

  local $_ = <DATA>;    # skip first line
  while (<DATA>) {
    chomp;
    next if /^\s*$/;
    my ( $country, $region, $timezone ) = split /\t/;
    $TIME_ZONE->{$country}->{ $region || '' } = $timezone;
  }

  # called from Geo::IP
  sub _time_zone {
    my ( undef, $country, $region  ) = @_;
    return undef unless $country;
    return undef unless defined $TIME_ZONE->{$country};
    $region ||= '';
    return
      defined $TIME_ZONE->{$country}->{$region}
      ? $TIME_ZONE->{$country}->{$region}
      : $TIME_ZONE->{$country}->{''};
  }
  sub time_zone {
    my ( $self ) = @_;
    my ( $country, $region ) = ( $self->country_code, $self->region );
    return $self->_time_zone( $country, $region );
  }
}

__PP__
1;
__DATA__
country	region	timezone
AD		Europe/Andorra
AE		Asia/Dubai
AF		Asia/Kabul
AG		America/Antigua
AI		America/Anguilla
AL		Europe/Tirane
AM		Asia/Yerevan
AN		America/Curacao
AO		Africa/Luanda
AQ		Antarctica/South_Pole
AR	01	America/Argentina/Buenos_Aires
AR	02	America/Argentina/Catamarca
AR	03	America/Argentina/Tucuman
AR	04	America/Argentina/Rio_Gallegos
AR	05	America/Argentina/Cordoba
AR	06	America/Argentina/Buenos_Aires
AR	07	America/Argentina/Buenos_Aires
AR	08	America/Argentina/Buenos_Aires
AR	09	America/Argentina/Tucuman
AR	10	America/Argentina/Jujuy
AR	11	America/Argentina/San_Luis
AR	12	America/Argentina/La_Rioja
AR	13	America/Argentina/Mendoza
AR	14	America/Argentina/Buenos_Aires
AR	15	America/Argentina/Mendoza
AR	16	America/Argentina/San_Luis
AR	17	America/Argentina/Salta
AR	18	America/Argentina/San_Juan
AR	19	America/Argentina/San_Luis
AR	20	America/Argentina/Rio_Gallegos
AR	21	America/Argentina/Cordoba
AR	22	America/Argentina/Catamarca
AR	23	America/Argentina/Ushuaia
AR	24	America/Argentina/Tucuman
AS		Pacific/Pago_Pago
AT		Europe/Vienna
AU	01	Australia/Sydney
AU	02	Australia/Sydney
AU	03	Australia/Darwin
AU	04	Australia/Brisbane
AU	05	Australia/Adelaide
AU	06	Australia/Hobart
AU	07	Australia/Melbourne
AU	08	Australia/Perth
AW		America/Aruba
AX		Europe/Mariehamn
AZ		Asia/Baku
BA		Europe/Sarajevo
BB		America/Barbados
BD		Asia/Dhaka
BE		Europe/Brussels
BF		Africa/Ouagadougou
BG		Europe/Sofia
BH		Asia/Bahrain
BI		Africa/Bujumbura
BJ		Africa/Porto-Novo
BM		Atlantic/Bermuda
BN		Asia/Brunei
BO		America/La_Paz
BR	01	America/Rio_Branco
BR	02	America/Maceio
BR	03	America/Belem
BR	04	America/Manaus
BR	05	America/Bahia
BR	06	America/Fortaleza
BR	07	America/Cuiaba
BR	08	America/Sao_Paulo
BR	11	America/Campo_Grande
BR	13	America/Araguaina
BR	14	America/Cuiaba
BR	15	America/Sao_Paulo
BR	16	America/Belem
BR	17	America/Recife
BR	18	America/Campo_Grande
BR	20	America/Fortaleza
BR	21	America/Sao_Paulo
BR	22	America/Recife
BR	23	America/Sao_Paulo
BR	24	America/Porto_Velho
BR	25	America/Boa_Vista
BR	26	America/Sao_Paulo
BR	27	America/Sao_Paulo
BR	28	America/Maceio
BR	29	America/Campo_Grande
BR	30	America/Recife
BR	31	America/Araguaina
BS		America/Nassau
BT		Asia/Thimphu
BV		Antarctica/Syowa
BW		Africa/Gaborone
BY		Europe/Minsk
BZ		America/Belize
CA	AB	America/Edmonton
CA	BC	America/Vancouver
CA	MB	America/Winnipeg
CA	NB	America/Halifax
CA	NL	America/St_Johns
CA	NS	America/Halifax
CA	NT	America/Yellowknife
CA	NU	America/Rankin_Inlet
CA	ON	America/Rainy_River
CA	PE	America/Halifax
CA	QC	America/Montreal
CA	SK	America/Regina
CA	YT	America/Whitehorse
CC		Indian/Cocos
CD	01	Africa/Kinshasa
CD	02	Africa/Kinshasa
CD	03	Africa/Kinshasa
CD	04	Africa/Lubumbashi
CD	05	Africa/Lubumbashi
CD	06	Africa/Kinshasa
CD	07	Africa/Lubumbashi
CD	08	Africa/Kinshasa
CD	09	Africa/Lubumbashi
CD	10	Africa/Lubumbashi
CD	11	Africa/Lubumbashi
CD	12	Africa/Lubumbashi
CF		Africa/Bangui
CG		Africa/Brazzaville
CH		Europe/Zurich
CI		Africa/Abidjan
CK		Pacific/Rarotonga
CL		America/Santiago
CM		Africa/Douala
CN	01	Asia/Shanghai
CN	02	Asia/Shanghai
CN	03	Asia/Shanghai
CN	04	Asia/Shanghai
CN	05	Asia/Harbin
CN	06	Asia/Chongqing
CN	07	Asia/Shanghai
CN	08	Asia/Harbin
CN	09	Asia/Shanghai
CN	10	Asia/Shanghai
CN	11	Asia/Chongqing
CN	12	Asia/Chongqing
CN	13	Asia/Urumqi
CN	14	Asia/Chongqing
CN	15	Asia/Chongqing
CN	16	Asia/Chongqing
CN	18	Asia/Chongqing
CN	19	Asia/Harbin
CN	20	Asia/Harbin
CN	21	Asia/Chongqing
CN	22	Asia/Harbin
CN	23	Asia/Shanghai
CN	24	Asia/Chongqing
CN	25	Asia/Shanghai
CN	26	Asia/Chongqing
CN	28	Asia/Shanghai
CN	29	Asia/Chongqing
CN	30	Asia/Chongqing
CN	31	Asia/Chongqing
CN	32	Asia/Chongqing
CN	33	Asia/Chongqing
CO		America/Bogota
CR		America/Costa_Rica
CU		America/Havana
CV		Atlantic/Cape_Verde
CX		Indian/Christmas
CY		Asia/Nicosia
CZ		Europe/Prague
DE		Europe/Berlin
DJ		Africa/Djibouti
DK		Europe/Copenhagen
DM		America/Dominica
DO		America/Santo_Domingo
DZ		Africa/Algiers
EC	01	Pacific/Galapagos
EC	02	America/Guayaquil
EC	03	America/Guayaquil
EC	04	America/Guayaquil
EC	05	America/Guayaquil
EC	06	America/Guayaquil
EC	07	America/Guayaquil
EC	08	America/Guayaquil
EC	09	America/Guayaquil
EC	10	America/Guayaquil
EC	11	America/Guayaquil
EC	12	America/Guayaquil
EC	13	America/Guayaquil
EC	14	America/Guayaquil
EC	15	America/Guayaquil
EC	17	America/Guayaquil
EC	18	America/Guayaquil
EC	19	America/Guayaquil
EC	22	America/Guayaquil
EC	24	America/Guayaquil
EE		Europe/Tallinn
EG		Africa/Cairo
EH		Africa/El_Aaiun
ER		Africa/Asmara
ES	07	Europe/Madrid
ES	27	Europe/Madrid
ES	29	Europe/Madrid
ES	31	Europe/Madrid
ES	32	Europe/Madrid
ES	34	Europe/Madrid
ES	39	Europe/Madrid
ES	51	Africa/Ceuta
ES	52	Europe/Madrid
ES	53	Atlantic/Canary
ES	54	Europe/Madrid
ES	55	Europe/Madrid
ES	56	Europe/Madrid
ES	57	Europe/Madrid
ES	58	Europe/Madrid
ES	59	Europe/Madrid
ES	60	Europe/Madrid
ET		Africa/Addis_Ababa
FI		Europe/Helsinki
FJ		Pacific/Fiji
FK		Atlantic/Stanley
FM		Pacific/Pohnpei
FO		Atlantic/Faroe
FR		Europe/Paris
GA		Africa/Libreville
GB		Europe/London
GD		America/Grenada
GE		Asia/Tbilisi
GF		America/Cayenne
GG		Europe/Guernsey
GH		Africa/Accra
GI		Europe/Gibraltar
GL	01	America/Thule
GL	02	America/Scoresbysund
GL	03	America/Godthab
GM		Africa/Banjul
GN		Africa/Conakry
GP		America/Guadeloupe
GQ		Africa/Malabo
GR		Europe/Athens
GS		Atlantic/South_Georgia
GT		America/Guatemala
GU		Pacific/Guam
GW		Africa/Bissau
GY		America/Guyana
HK		Asia/Hong_Kong
HN		America/Tegucigalpa
HR		Europe/Zagreb
HT		America/Port-au-Prince
HU		Europe/Budapest
ID	01	Asia/Pontianak
ID	02	Asia/Makassar
ID	03	Asia/Jakarta
ID	04	Asia/Jakarta
ID	05	Asia/Jakarta
ID	07	Asia/Jakarta
ID	08	Asia/Jakarta
ID	10	Asia/Jakarta
ID	11	Asia/Pontianak
ID	12	Asia/Makassar
ID	13	Asia/Pontianak
ID	14	Asia/Makassar
ID	15	Asia/Jakarta
ID	17	Asia/Makassar
ID	18	Asia/Makassar
ID	21	Asia/Makassar
ID	22	Asia/Makassar
ID	24	Asia/Jakarta
ID	26	Asia/Pontianak
ID	28	Asia/Jayapura
ID	29	Asia/Makassar
ID	30	Asia/Jakarta
ID	31	Asia/Makassar
ID	32	Asia/Jakarta
ID	33	Asia/Jakarta
ID	34	Asia/Makassar
ID	35	Asia/Pontianak
ID	36	Asia/Jayapura
ID	37	Asia/Pontianak
ID	38	Asia/Makassar
ID	39	Asia/Jayapura
ID	40	Asia/Pontianak
ID	41	Asia/Makassar
IE		Europe/Dublin
IL		Asia/Jerusalem
IM		Europe/Isle_of_Man
IN		Asia/Kolkata
IO		Indian/Chagos
IQ		Asia/Baghdad
IR		Asia/Tehran
IS		Atlantic/Reykjavik
IT		Europe/Rome
JE		Europe/Jersey
JM		America/Jamaica
JO		Asia/Amman
JP		Asia/Tokyo
KE		Africa/Nairobi
KG		Asia/Bishkek
KH		Asia/Phnom_Penh
KI		Pacific/Tarawa
KM		Indian/Comoro
KN		America/St_Kitts
KP		Asia/Pyongyang
KR		Asia/Seoul
KW		Asia/Kuwait
KY		America/Cayman
KZ	01	Asia/Almaty
KZ	02	Asia/Almaty
KZ	03	Asia/Qyzylorda
KZ	04	Asia/Aqtobe
KZ	05	Asia/Qyzylorda
KZ	06	Asia/Aqtau
KZ	07	Asia/Oral
KZ	08	Asia/Qyzylorda
KZ	09	Asia/Aqtau
KZ	10	Asia/Qyzylorda
KZ	11	Asia/Almaty
KZ	12	Asia/Almaty
KZ	13	Asia/Aqtobe
KZ	14	Asia/Qyzylorda
KZ	15	Asia/Almaty
KZ	16	Asia/Aqtobe
KZ	17	Asia/Almaty
LA		Asia/Vientiane
LB		Asia/Beirut
LC		America/St_Lucia
LI		Europe/Vaduz
LK		Asia/Colombo
LR		Africa/Monrovia
LS		Africa/Maseru
LT		Europe/Vilnius
LU		Europe/Luxembourg
LV		Europe/Riga
LY		Africa/Tripoli
MA		Africa/Casablanca
MC		Europe/Monaco
MD		Europe/Chisinau
ME		Europe/Podgorica
MG		Indian/Antananarivo
MH		Pacific/Kwajalein
MK		Europe/Skopje
ML		Africa/Bamako
MM		Asia/Rangoon
MN	06	Asia/Choibalsan
MN	11	Asia/Ulaanbaatar
MN	17	Asia/Choibalsan
MN	19	Asia/Hovd
MN	20	Asia/Ulaanbaatar
MN	21	Asia/Ulaanbaatar
MN	25	Asia/Ulaanbaatar
MO		Asia/Macau
MP		Pacific/Saipan
MQ		America/Martinique
MR		Africa/Nouakchott
MS		America/Montserrat
MT		Europe/Malta
MU		Indian/Mauritius
MV		Indian/Maldives
MW		Africa/Blantyre
MX	01	America/Bahia_Banderas
MX	02	America/Tijuana
MX	03	America/Mazatlan
MX	04	America/Merida
MX	05	America/Merida
MX	06	America/Chihuahua
MX	07	America/Monterrey
MX	08	America/Bahia_Banderas
MX	09	America/Mexico_City
MX	10	America/Mazatlan
MX	11	America/Mexico_City
MX	12	America/Mexico_City
MX	13	America/Mexico_City
MX	14	America/Bahia_Banderas
MX	15	America/Mexico_City
MX	16	America/Mexico_City
MX	17	America/Mexico_City
MX	18	America/Bahia_Banderas
MX	19	America/Monterrey
MX	20	America/Mexico_City
MX	21	America/Mexico_City
MX	22	America/Mexico_City
MX	23	America/Cancun
MX	24	America/Mexico_City
MX	25	America/Mazatlan
MX	26	America/Hermosillo
MX	27	America/Merida
MX	28	America/Matamoros
MX	29	America/Mexico_City
MX	30	America/Mexico_City
MX	31	America/Merida
MX	32	America/Bahia_Banderas
MY	01	Asia/Kuala_Lumpur
MY	02	Asia/Kuala_Lumpur
MY	03	Asia/Kuala_Lumpur
MY	04	Asia/Kuala_Lumpur
MY	05	Asia/Kuala_Lumpur
MY	06	Asia/Kuala_Lumpur
MY	07	Asia/Kuala_Lumpur
MY	08	Asia/Kuala_Lumpur
MY	09	Asia/Kuala_Lumpur
MY	11	Asia/Kuching
MY	12	Asia/Kuala_Lumpur
MY	13	Asia/Kuala_Lumpur
MY	14	Asia/Kuala_Lumpur
MY	15	Asia/Kuching
MY	16	Asia/Kuching
MZ		Africa/Maputo
NA		Africa/Windhoek
NC		Pacific/Noumea
NE		Africa/Niamey
NF		Pacific/Norfolk
NG		Africa/Lagos
NI		America/Managua
NL		Europe/Amsterdam
NO		Europe/Oslo
NP		Asia/Kathmandu
NR		Pacific/Nauru
NU		Pacific/Niue
NZ	E7	Pacific/Auckland
NZ	E8	Pacific/Auckland
NZ	E9	Pacific/Auckland
NZ	F1	Pacific/Auckland
NZ	F2	Pacific/Auckland
NZ	F3	Pacific/Auckland
NZ	F4	Pacific/Auckland
NZ	F5	Pacific/Auckland
NZ	F6	Pacific/Auckland
NZ	F7	Pacific/Chatham
NZ	F8	Pacific/Auckland
NZ	F9	Pacific/Auckland
NZ	G1	Pacific/Auckland
NZ	G2	Pacific/Auckland
NZ	G3	Pacific/Auckland
OM		Asia/Muscat
PA		America/Panama
PE		America/Lima
PF		Pacific/Marquesas
PG		Pacific/Port_Moresby
PH		Asia/Manila
PK		Asia/Karachi
PL		Europe/Warsaw
PM		America/Miquelon
PR		America/Puerto_Rico
PS		Asia/Gaza
PT	02	Europe/Lisbon
PT	03	Europe/Lisbon
PT	04	Europe/Lisbon
PT	05	Europe/Lisbon
PT	06	Europe/Lisbon
PT	07	Europe/Lisbon
PT	08	Europe/Lisbon
PT	09	Europe/Lisbon
PT	10	Atlantic/Madeira
PT	11	Europe/Lisbon
PT	13	Europe/Lisbon
PT	14	Europe/Lisbon
PT	16	Europe/Lisbon
PT	17	Europe/Lisbon
PT	18	Europe/Lisbon
PT	19	Europe/Lisbon
PT	20	Europe/Lisbon
PT	21	Europe/Lisbon
PT	22	Europe/Lisbon
PT	23	Atlantic/Azores
PW		Pacific/Palau
PY		America/Asuncion
QA		Asia/Qatar
RE		Indian/Reunion
RO		Europe/Bucharest
RS		Europe/Belgrade
RU	01	Europe/Volgograd
RU	02	Asia/Irkutsk
RU	03	Asia/Novokuznetsk
RU	04	Asia/Novosibirsk
RU	05	Asia/Vladivostok
RU	06	Europe/Moscow
RU	07	Europe/Volgograd
RU	08	Europe/Samara
RU	09	Europe/Volgograd
RU	10	Europe/Moscow
RU	11	Asia/Irkutsk
RU	12	Europe/Volgograd
RU	13	Asia/Yekaterinburg
RU	14	Asia/Irkutsk
RU	15	Asia/Anadyr
RU	16	Europe/Samara
RU	17	Europe/Volgograd
RU	18	Asia/Krasnoyarsk
RU	20	Asia/Irkutsk
RU	21	Europe/Moscow
RU	22	Europe/Volgograd
RU	23	Europe/Kaliningrad
RU	24	Europe/Volgograd
RU	25	Europe/Moscow
RU	26	Asia/Kamchatka
RU	27	Europe/Volgograd
RU	28	Europe/Moscow
RU	29	Asia/Novokuznetsk
RU	30	Asia/Sakhalin
RU	31	Asia/Krasnoyarsk
RU	32	Asia/Yekaterinburg
RU	33	Europe/Samara
RU	34	Asia/Yekaterinburg
RU	36	Asia/Anadyr
RU	37	Europe/Moscow
RU	38	Europe/Volgograd
RU	39	Asia/Krasnoyarsk
RU	40	Asia/Yekaterinburg
RU	41	Europe/Moscow
RU	42	Europe/Moscow
RU	43	Europe/Moscow
RU	44	Asia/Magadan
RU	45	Europe/Samara
RU	46	Europe/Samara
RU	47	Europe/Moscow
RU	48	Europe/Moscow
RU	49	Europe/Moscow
RU	50	Asia/Yekaterinburg
RU	51	Europe/Moscow
RU	52	Europe/Moscow
RU	53	Asia/Novosibirsk
RU	54	Asia/Omsk
RU	55	Europe/Samara
RU	56	Europe/Moscow
RU	57	Europe/Samara
RU	58	Asia/Yekaterinburg
RU	59	Asia/Vladivostok
RU	60	Europe/Moscow
RU	61	Europe/Volgograd
RU	62	Europe/Moscow
RU	63	Asia/Yakutsk
RU	64	Asia/Sakhalin
RU	65	Europe/Samara
RU	66	Europe/Moscow
RU	67	Europe/Samara
RU	68	Europe/Volgograd
RU	69	Europe/Moscow
RU	70	Europe/Volgograd
RU	71	Asia/Yekaterinburg
RU	72	Europe/Moscow
RU	73	Europe/Samara
RU	74	Asia/Yakutsk
RU	75	Asia/Novosibirsk
RU	76	Europe/Moscow
RU	77	Europe/Moscow
RU	78	Asia/Omsk
RU	79	Asia/Irkutsk
RU	80	Asia/Yekaterinburg
RU	81	Europe/Samara
RU	83	Europe/Moscow
RU	84	Europe/Volgograd
RU	85	Europe/Moscow
RU	86	Europe/Volgograd
RU	87	Asia/Omsk
RU	88	Europe/Moscow
RU	89	Asia/Vladivostok
RU	90	Asia/Yekaterinburg
RU	91	Asia/Krasnoyarsk
RU	92	Asia/Anadyr
RU	93	Asia/Irkutsk
RU	CI	Europe/Volgograd
RU	JA	Asia/Sakhalin
RW		Africa/Kigali
SA		Asia/Riyadh
SB		Pacific/Guadalcanal
SC		Indian/Mahe
SD		Africa/Khartoum
SE		Europe/Stockholm
SG		Asia/Singapore
SH		Atlantic/St_Helena
SI		Europe/Ljubljana
SJ		Arctic/Longyearbyen
SK		Europe/Bratislava
SL		Africa/Freetown
SM		Europe/San_Marino
SN		Africa/Dakar
SO		Africa/Mogadishu
SR		America/Paramaribo
ST		Africa/Sao_Tome
SV		America/El_Salvador
SY		Asia/Damascus
SZ		Africa/Mbabane
TC		America/Grand_Turk
TD		Africa/Ndjamena
TF		Indian/Kerguelen
TG		Africa/Lome
TH		Asia/Bangkok
TJ		Asia/Dushanbe
TK		Pacific/Fakaofo
TL		Asia/Dili
TM		Asia/Ashgabat
TN		Africa/Tunis
TO		Pacific/Tongatapu
TR		Europe/Istanbul
TT		America/Port_of_Spain
TV		Pacific/Funafuti
TW		Asia/Taipei
TZ		Africa/Dar_es_Salaam
UA	01	Europe/Kiev
UA	02	Europe/Kiev
UA	03	Europe/Uzhgorod
UA	04	Europe/Zaporozhye
UA	05	Europe/Zaporozhye
UA	06	Europe/Uzhgorod
UA	07	Europe/Zaporozhye
UA	08	Europe/Simferopol
UA	09	Europe/Kiev
UA	10	Europe/Zaporozhye
UA	11	Europe/Simferopol
UA	12	Europe/Kiev
UA	13	Europe/Kiev
UA	14	Europe/Zaporozhye
UA	15	Europe/Uzhgorod
UA	16	Europe/Zaporozhye
UA	17	Europe/Simferopol
UA	18	Europe/Zaporozhye
UA	19	Europe/Kiev
UA	20	Europe/Simferopol
UA	21	Europe/Kiev
UA	22	Europe/Uzhgorod
UA	23	Europe/Kiev
UA	24	Europe/Uzhgorod
UA	25	Europe/Uzhgorod
UA	26	Europe/Zaporozhye
UA	27	Europe/Kiev
UG		Africa/Kampala
UM		Pacific/Wake
US	AK	America/Anchorage
US	AL	America/Chicago
US	AR	America/Chicago
US	AZ	America/Phoenix
US	CA	America/Los_Angeles
US	CO	America/Denver
US	CT	America/New_York
US	DC	America/New_York
US	DE	America/New_York
US	FL	America/New_York
US	GA	America/New_York
US	HI	Pacific/Honolulu
US	IA	America/Chicago
US	ID	America/Denver
US	IL	America/Chicago
US	IN	America/Indianapolis
US	KS	America/Chicago
US	KY	America/New_York
US	LA	America/Chicago
US	MA	America/New_York
US	MD	America/New_York
US	ME	America/New_York
US	MI	America/New_York
US	MN	America/Chicago
US	MO	America/Chicago
US	MS	America/Chicago
US	MT	America/Denver
US	NC	America/New_York
US	ND	America/Chicago
US	NE	America/Chicago
US	NH	America/New_York
US	NJ	America/New_York
US	NM	America/Denver
US	NV	America/Los_Angeles
US	NY	America/New_York
US	OH	America/New_York
US	OK	America/Chicago
US	OR	America/Los_Angeles
US	PA	America/New_York
US	RI	America/New_York
US	SC	America/New_York
US	SD	America/Chicago
US	TN	America/Chicago
US	TX	America/Chicago
US	UT	America/Denver
US	VA	America/New_York
US	VT	America/New_York
US	WA	America/Los_Angeles
US	WI	America/Chicago
US	WV	America/New_York
US	WY	America/Denver
UY		America/Montevideo
UZ	01	Asia/Tashkent
UZ	02	Asia/Samarkand
UZ	03	Asia/Tashkent
UZ	05	Asia/Samarkand
UZ	06	Asia/Tashkent
UZ	07	Asia/Samarkand
UZ	08	Asia/Samarkand
UZ	10	Asia/Samarkand
UZ	12	Asia/Samarkand
UZ	13	Asia/Tashkent
UZ	14	Asia/Tashkent
VA		Europe/Vatican
VC		America/St_Vincent
VE		America/Caracas
VG		America/Tortola
VI		America/St_Thomas
VN		Asia/Ho_Chi_Minh
VU		Pacific/Efate
WF		Pacific/Wallis
WS		Pacific/Apia
YE		Asia/Aden
YT		Indian/Mayotte
ZA		Africa/Johannesburg
ZM		Africa/Lusaka
ZW		Africa/Harare
SX		America/Curacao
BQ		America/Curacao
CW		America/Curacao
BL		America/St_Barthelemy
PN		Pacific/Pitcairn
