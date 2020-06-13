C:
cd C:\Program Files\FlightGear 2019.1.2
SET FG_ROOT=C:\Program Files\FlightGear 2019.1.2\data\
SET FG_SCENERY=C:\Program Files\FlightGear 2019.1.2\data\Scenery
.\\bin\fgfs --aircraft=falcon9 --fdm=null --enable-auto-coordination --native-fdm=socket,in,30,localhost,5502,udp --fog-nicest --enable-clouds3d --start-date-lat=2004:06:01:09:00:00 --enable-sound --visibility=15000 --in-air --prop:/engines/engine0/running=true --disable-freeze --airport=PHNL --altitude=80 --heading=0 --offset-distance=0 --offset-azimuth=0 --enable-rembrandt --enable-hud