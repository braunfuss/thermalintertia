# thermalintertia
Also unter Matlab ist exampleinput.mat zu finden, welches erst eingeladen werden muss. Das enthält zwei Datenbeispiele.

Das meißte sind Unterfunktionen.

Die beiden Hauptüberfunktionen hier heißen:

optimrtiraw.m

optimrtisoilmoisture.m

Beide sollten ganz einfach ausgeführt werden können. Es popt ein Fenster mit dem Datensatz auf (Delta T). Dort kann mit der linken Maustauste Quadtrate gezogen werden um Bereiche auszuschließen. Wenn man das nicht will oder fertig ist, entweder die rechte Maustauste oder mittlere einfach irgendwo im Bild drücken. Dann geht es weiter.

Bei indepent runs ist jeweils 5 eingestellt. Das läuft ziemlich lange durch. 

Das erste Skript kalkuliert die Eigenschaften auf Basis von Dichte, Wärmekapaz. und Leitfähigkeit. Es nimmt derzeit ein Zwei Schicht modell an, das lässt sich aber ausbauen. 
Das Ergebniss wird pro Quadtree abgespeichert und enhält die Dichte, Wärmekap. und Wärmeleitfähigkeitwerte die für einen Durchlauf den niedriegsten Misfit erzeugen.

Das zweite kalkuliert die Bodenfeuchte und Dichte als Output mithilfe einer numerischen Lösung (wie erwähnt da sollten wir mal selber eine antrainieren).

Bei beiden Skripten wird derzeit die ALbedo mit optimiert, aber das lässt sich auch beheben wie erwähnt.



