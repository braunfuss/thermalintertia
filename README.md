# thermalintertia
Im Ordner ist exampleinput.mat zu finden, welches erst eingeladen werden muss. Dieses enthält zwei Datenbeispiele.

Das meißte der angeführten Funktionen sind Unterfunktionen.

Die beiden Hauptüberfunktionen hier heißen:

optimrtiraw.m

optimrtisoilmoisture.m


Das erste Skript kalkuliert die Eigenschaften auf Basis von Dichte, Wärmekapaz. und Leitfähigkeit. Es nimmt derzeit ein Zwei Schicht modell an, das lässt sich aber ausbauen. 
Das Ergebniss wird pro Quadtree abgespeichert und enhält die Dichte, Wärmekap. und Wärmeleitfähigkeitwerte die für einen Durchlauf den niedriegsten Misfit erzeugen.

Das zweite kalkuliert die Bodenfeuchte und Dichte als Output mithilfe einer numerischen Lösung (wie erwähnt da sollten wir mal selber eine antrainieren).



Beide sollten ganz einfach ausgeführt werden können. Es popt ein Fenster mit dem Datensatz auf (Delta T). Dort kann mit der linken Maustauste Quadtrate gezogen werden um Bereiche auszuschließen. Wenn man das nicht will oder fertig ist, entweder die rechte Maustauste oder mittlere einfach irgendwo im Bild drücken. Dann geht es weiter.

Bei indepent runs ist jeweils 5 eingestellt. Das läuft ziemlich lange durch. 



Bei beiden Skripten wird derzeit die Albedo mit optimiert, aber das lässt sich auch beheben wie erwähnt.


quadtree fct is from J́onsson, S., Zebker, H.A., Segall, P. & Amelung, F., 2002. Fault slip distri bution of the 1999 Mw7.2 Hector Mine earthquake, California, estimated from satellite radar and GPS measurements, Bull. seism. Soc. Am., 92(4)



