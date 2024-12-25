from datetime import datetime
import pytz

# Obtener la hora actual en UTC
utc_now = datetime.utcnow()

# Configurar la zona horaria de Madrid
timezone = pytz.timezone("Europe/Madrid")
local_time = utc_now.replace(tzinfo=pytz.utc).astimezone(timezone)

# Imprimir la hora local
print(f"Hora local de ejecución: {local_time}")
