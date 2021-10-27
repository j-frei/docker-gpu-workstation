# Infos und Beispiele zur Nutzung eines SSH-Containers

Für die ersten Schritte auf der Workstation mit ssh sind folgende Befehle relevant.  
**Ihr benötigt in jedem Fall das Uni-VPN!**

Benötigte Informationen:
- SSH-Port
- SSH-Passwort

## Erste Schritte

Einloggen (Auf eurem Rechner/Kommandozeile eingeben!):
```bash
ssh -p <SSH-Port> root@misit180.informatik.uni-augsburg.de
# Beim ersten Verbinden den Fingerprint des Servers bestätigen!
# Zum Einloggen das SSH-Passwort eingeben
```

SSH-Passwort ändern (Innerhalb der SSH-Umgebung): 
```bash
echo 'root:mein_neues_passwort' | chpasswd
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

## Spezifisches zur VM-Workstation

Alle Daten werden beim Löschen des Containers entfernt.  
**Zwei Verzeichnisse bleiben jedoch persistent**:
- `/data`: schneller, NVMe-Speicher, jedoch nicht ausfallgesichert und prinzipiell weniger Speicherplatz
- `/storage`: schneller SATA-SSD (RAID 10)-Verbund, vor Hardwareschäden geschützt, viel Speicherplatz


## Nütliche Infos

Weitere Befehle wie den ls- oder cat-Befehl findet ihr auch diversen Cheat-Sheets wie hier:  
https://cheatography.com/davechild/cheat-sheets/linux-command-line/

Datei auf euren lokalen Rechner kopieren (Auf eurem Rechner/Kommandozeile eingeben!):
```bash
scp -P <SSH-Port> root@misit180.informatik.uni-augsburg.de:/root/datei.txt datei_lokal.txt
```

Anders herum dann so (Auf eurem Rechner/Kommandozeile eingeben!):
```bash
scp -P <SSH-Port> datei_lokal.txt root@misit180.informatik.uni-augsburg.de:/root/datei.txt
```

Mit der Erweiterung SSH Remote könnt ihr auch direkt in VS Code arbeiten.  
https://code.visualstudio.com/docs/remote/ssh-tutorial

Eine ähnliche Möglichkeit gibt es auch für PyCharm, wenn ihr die Professional-Edition nutzt. (über euren Studentenstatus könnt ihr eine Lizenz bekommen)  
https://www.jetbrains.com/help/pycharm/tutorial-using-the-product-built-in-ssh-terminal-and-remote-ssh-external-tools.html

Bei einer Jupyter-Lab/Hub-Instanz mit zusätzlich gegebenen `Jupyter-Port` könnt ihr unter folgender Adresse darauf zugreifen:  
`https://misit180.informatik.uni-augsburg.de:<Jupyter-Port>`  
Wichtig ist, dass ihr auf "https" am Anfang achtet, damit es funktioniert.

Alles oben genannte funktioniert nur MIT UNI-VPN!
