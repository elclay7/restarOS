#!/bin/bash

logfile="/var/log/restarOS.log"

obtener_fecha_hora() {
  date +"%d-%m-%Y %H:%M:%S"
}

echo "$(obtener_fecha_hora) Inicia script /root/restarOS.sh" >> "$logfile"

# Inicialización de variables
tiempo=0

# Bucle principal
while true; do
  if ! ping -c 1 cl.pool.ntp.org > /dev/null; then
    fecha_hora_ping=$(obtener_fecha_hora)
    echo "$fecha_hora_ping Ping fallido" >> "$logfile"
    
    # Incrementa el tiempo acumulado en 10 segundos
    tiempo=$((tiempo + 10))
    
    # Si el tiempo acumulado supera los 120 segundos, reinicia el sistema operativo
    if [ $tiempo -ge 120 ]; then
      fecha_hora_evento=$(obtener_fecha_hora)
      echo "$fecha_hora_evento El ping a cl.pool.ntp.org no respondió durante 2 minuto" >> "$logfile"
      echo "$fecha_hora_evento Reiniciando el sistema operativo" >> "$logfile"
      reboot
    fi
  else
    # Si el ping responde, reinicia el contador de tiempo acumulado
    tiempo=0
  fi

  sleep 10

done
