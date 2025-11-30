import pandas as pd
import os
from database import engine
from config import DATA_PATH

CSV_FILES = {
    "usuarios.csv": "usuarios",
    "categorias.csv": "categorias",
    "productos.csv": "productos",
    "ordenes.csv": "ordenes",
    "detalle_ordenes.csv": "detalle_ordenes",
    "direcciones_envio.csv": "direcciones_envio",
    "carrito.csv": "carrito",
    "metodos_pago.csv": "metodos_pago",
    "ordenes_metodospago.csv": "ordenes_metodospago",
    "resenas_productos.csv": "resenas_productos",
    "historial_pagos.csv": "historial_pagos"
}

# Mapeo de columnas CSV → nombres estándar en BD
COLUMN_MAPPING = {
    "UsuarioID": "usuario_id",
    "Calle": "calle",
    "Departamento": "departamento",
    "Estado": "estado",
    "Distrito": "distrito",
    "Pais": "pais",
    "CodigoPostal": "codigo_postal",
    "Provincia": "provincia",
    "usuarioid": "usuario_id",
    "OrdenID": "orden_id",
    "ordenid": "orden_id",
    "ProductoID": "producto_id",
    "productoid": "producto_id",
    "CategoriaID": "categoria_id",
    "categoriaid": "categoria_id",
    "MetodoPagoID": "metodo_id",
    "metodoid": "metodo_id",
    "FechaOrden": "fecha_orden",
    "fechaorden": "fecha_orden",
    "FechaAgregado": "fecha_agregado",
    "fechaagregado": "fecha_agregado",
    "FechaPago": "fecha_pago",
    "fechapago": "fecha_pago",
    "PrecioUnitario": "precio_unitario",
    "preciounitario": "precio_unitario",
    "MontoPagado": "monto_pagado",
    "montopagado": "monto_pagado",
    "Monto": "monto",
    "monto": "monto",
    "Nombre": "nombre",
    "nombre": "nombre",
    "Descripcion": "descripcion",
    "descripcion": "descripcion",
    "Precio": "precio",
    "precio": "precio",
    "Stock": "stock",
    "stock": "stock",
    "Cantidad": "cantidad",
    "cantidad": "cantidad",
    "Total": "total",
    "total": "total",
    "Estado": "estado",
    "estado": "estado",
    "DNI": "dni",
    "dni": "dni",
    "Email": "email",
    "email": "email",
    "Contraseña": "contrasena",
    "contrasena": "contrasena",
    "Apellido": "apellido",
    "apellido": "apellido",
    "Comentario": "comentario",
    "comentario": "comentario",
    "Calificacion": "calificacion",
    "calificacion": "calificacion",
    "Fecha": "fecha",
    "fecha": "fecha",
    "Ciudad": "ciudad",
    "ciudad": "ciudad",
    "Provincia": "provincia",
    "provincia": "provincia",
    "Pais": "pais",
    "pais": "pais",
    "CodigoPostal": "codigo_postal",
    "codigopostal": "codigo_postal",
    "EstadoPago": "estado_pago",
    "estadopago": "estado_pago"
}

def map_columns(df):
    """Mapea columnas CSV a nombres estándar en BD"""
    rename_dict = {}
    for col in df.columns:
        if col in COLUMN_MAPPING:
            rename_dict[col] = COLUMN_MAPPING[col]
    df = df.rename(columns=rename_dict)
    return df

def load_csv_to_db(filename, table_name):
    """Carga CSV a BD"""
    try:
        filepath = os.path.join(DATA_PATH, filename)
        df = pd.read_csv(filepath)
        df = map_columns(df)
        df = df.where(pd.notnull(df), None)
        
        df.to_sql(table_name, con=engine, schema='staging',
                  if_exists='append', index=False)
        
        print(f"✓ {table_name}: {len(df)} filas")
        return len(df)
    except Exception as e:
        print(f"✗ {filename}: {e}")
        return 0

def load_all():
    """Carga todos los CSVs"""
    print("="*60)
    print("CARGA DE DATOS - STAGING")
    print("="*60)
    
    total = 0
    for csv_file, table in CSV_FILES.items():
        total += load_csv_to_db(csv_file, table)
    
    print("="*60)
    print(f"TOTAL: {total} filas")
    print("="*60)

if __name__ == "__main__":
    load_all()