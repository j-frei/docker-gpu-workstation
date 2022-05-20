# Infos und Beispiele zur Nutzung eines SSH-Containers

Für die ersten Schritte auf der Workstation mit ssh sind folgende Befehle relevant.  
**Ihr benötigt in jedem Fall das Uni-VPN!**

Benötigte Informationen:
- SSH-Port
- SSH-Passwort

## Erste Schritte

Einloggen (Auf eurem Rechner/Kommandozeile eingeben!):
```bash
ssh -p <SSH-Port> main@misit180.informatik.uni-augsburg.de
# Beim ersten Verbinden den Fingerprint des Servers bestätigen!
# Zum Einloggen das SSH-Passwort eingeben
```

SSH-Passwort ändern (Innerhalb der SSH-Umgebung): 
```bash
echo 'main:mein_neues_passwort' | chpasswd
```

Ausloggen (Innerhalb der SSH-Umgebung):
```bash
exit
```

## Weitere Befehle

Aktuelles Verzeichnis ausgeben (Innerhalb der SSH-Umgebung):
```bash
pwd
```

Verzeichnis wechseln (Innerhalb der SSH-Umgebung):
```bash
cd neues_verzeichnis
```

Aus dem Verzeichnis wieder raus (Innerhalb der SSH-Umgebung):
```bash
cd ..
```

Datei kopieren (Innerhalb der SSH-Umgebung):
```bash
cp datei.txt neue_datei.txt
```

Datei verschieben (Innerhalb der SSH-Umgebung):
```bash
mv datei.txt neue_datei.txt
```

Datei löschen (Innerhalb der SSH-Umgebung):
```bash
rm datei.txt
```

Textdatei schreiben (Innerhalb der SSH-Umgebung):
```bash
# Einfaches > überschreibt ggf. bestehende Dateien komplett
echo "Erste Testzeile" > testdatei.txt

# Weitere Zeilen anhängen mittels >>
echo "Weitere Zeile" >> testdatei.txt
```  
Textdateien lassen sich auch mit Texteditoren bearbeiten: (siehe `nano testdatei.txt`, `vi testdatei.txt`)

Textdateien anzeigen lassen (Innerhalb der SSH-Umgebung):
```bash
cat testdatei.txt
```

Laufendes Programm abbrechen (Innerhalb der SSH-Umgebung):
```bash
# 1000 Sekunden laufendes Programm
sleep 1000
# Nun STRG+C drücken, um das Programm `sleep` abzubrechen
```  
Falls das Programm nicht darauf reagiert, muss der Prozess gekillt werden.

Laufenden Prozess killen (Innerhalb der SSH-Umgebung):
```bash
# Bestehende Prozess-ID (PID) finden
ps -aux | grep "python3 script.py"
# Ausgabe:
# root     123456  <........> python3 script.py

# Höfliches Beenden (SigTerm)
kill 123456
# Brutales Beenden (SigKill)
kill -9 123456
# Bei fehlenden Berechtigungen
sudo kill 123456
sudo kill -9 123456

# Alle python3-Prozesse killen mit pkill / killall
[sudo] killall [-9] python3
[sudo] pkill [-9] python3
```

## Befehle von SSH-Sitzung entkoppeln
Bei Abbruch oder Beenden der SSH-Verbindung werden die laufenden Prozesse der Sitzung geschlossen. Um länger laufende Prozesse auch unabhängig von der SSH-Verbindung laufen zu lassen, gibt es verschiedene Möglichkeiten:
- Mittels `nohup`:  
  Wenn der Befehl `python3 script.py` auch nach der SSH-Sitzung weiterlaufen soll, kann der Prozess mittels  
  ```bash
  nohup python3 script.py >ausgabe.txt 2>&1 &
  ```  
  gestartet werden. Dabei wird die Ausgabe (inkl. Fehlermeldungen) in die Datei ausgabe.txt geschrieben (und können mit `cat ausgabe.txt` oder `tail -fn +1 ausgabe.txt` (folgt auchneuen Zeilen) gelesen werden).
- Mittels `tmux`:  
  Für eine neue Sitzung in Tmux muss eine neue Tmux-Sitzung gestartet werden:  
  `tmux new -s neueSitzung` (Sitzungsname ist `neueSitzung`) Anschließend kann der Befehl gestartet werden. Die Tmux-Sitzung kann mit dem gleichzeitigen Drücken von STRG+b, gefolgt von der Taste d verlassen werden, ohne dass der laufende Prozess beendet wird.  
  `tmux ls` zeigt laufende Tmux-Sitzungen an.  
  `tmux a -t neueSitzung` wird verwendet, um laufende Sitzungen wieder zu betreten.  
  Cheatsheet: http://tmuxcheatsheet.com/
- Mittels SPICE/RDP (nur bei "echten" VMs):  
  Via graphischer Oberfläche können innerhalb der VM-Umgebung ein Terminal mit Prozessen gestartet werden. Die SPICE/RDP-Sitzung kann unterbrochen werden und später wieder aufgenommen werden, ohne das die Prozesse in der VM unterbrochen werden.

## Spezifisches zur VM-Workstation

Alle Daten werden beim Löschen des Containers entfernt.  
**Zwei Verzeichnisse bleiben jedoch persistent**:
- `/data`: schneller, NVMe-Speicher, jedoch nicht ausfallgesichert und prinzipiell weniger Speicherplatz
- `/storage`: schneller SATA-SSD (RAID 10)-Verbund, vor Hardwareschäden geschützt, viel Speicherplatz

Gegebenenfalls müssen die Zugriffsrechte beim ersten Zugriff angepasst werden.  
```bash
sudo chown -R main:main /data
sudo chown -R main:main /storage
```

Wichtige Info: Der Speicherplatz für nicht-mounts ist auf 20G limitiert. Größere Daten müssen auf die Mounts (/storage, /data) geschrieben werden.


## Nützliche Infos

Weitere Befehle wie den ls- oder cat-Befehl findet ihr auch diversen Cheat-Sheets wie hier:  
https://cheatography.com/davechild/cheat-sheets/linux-command-line/

Datei auf euren lokalen Rechner kopieren (Auf eurem Rechner/Kommandozeile eingeben!):
```bash
scp -P <SSH-Port> main@misit180.informatik.uni-augsburg.de:/home/main/datei.txt datei_lokal.txt
```

Anders herum dann so (Auf eurem Rechner/Kommandozeile eingeben!):
```bash
scp -P <SSH-Port> datei_lokal.txt main@misit180.informatik.uni-augsburg.de:/home/main/datei.txt
```

Mit der Erweiterung SSH Remote könnt ihr auch direkt in VS Code arbeiten.  
https://code.visualstudio.com/docs/remote/ssh-tutorial

Eine ähnliche Möglichkeit gibt es auch für PyCharm, wenn ihr die Professional-Edition nutzt. (über euren Studentenstatus könnt ihr eine Lizenz bekommen)  
https://www.jetbrains.com/help/pycharm/tutorial-using-the-product-built-in-ssh-terminal-and-remote-ssh-external-tools.html

Bei einer Jupyter-Lab/Hub-Instanz mit zusätzlich gegebenen `Jupyter-Port` könnt ihr unter folgender Adresse darauf zugreifen:  
`https://misit180.informatik.uni-augsburg.de:<Jupyter-Port>`  
Wichtig ist, dass ihr auf "https" am Anfang achtet, damit es funktioniert.

Alles oben genannte funktioniert nur MIT UNI-VPN!
