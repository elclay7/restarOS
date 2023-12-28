#!/bin/bash
logfile="/var/log/restarOS.log"
fecha_hora=$(date +"%d-%m-%Y %H:%M:%S")
echo "$fecha_hora Inicio del script restarOS.sh" >> "$logfile"
tiempo=0

while true; do

  ping -c 1 cl.pool.ntp.org > /dev/null

  # Si el ping no respondió, incrementa el tiempo acumulado
  if [ $? -ne 0 ]; then
    tiempo=$((tiempo + 10)) # Incrementa la variable de tiempo en 10 segundos
  else
    # Si el ping responde, reinicia el contador de tiempo acumulado
    tiempo=0
  fi

  # Si el tiempo acumulado supera los 300 segundos (5 minutos), reinicia el sistema operativo
  if [ $tiempo -ge 300 ]; then
    fecha_hora_evento=$(date +"%d-%m-%Y %H:%M:%S")
    echo "$fecha_hora_evento El ping a cl.pool.ntp.org no respondió durante 5 minutos" >> "$logfile"
    echo "$fecha_hora_evento Reiniciando el sistema operativo" >> "$logfile"
    reboot
  fi

  sleep 10

done

