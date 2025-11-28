import os
import boto3
from botocore.exceptions import ClientError

ses = boto3.client("ses")  # usa la región/configuración por defecto del runtime

def lambda_handler(event, context):
    to_email = "fernandopunales@gmail.com"               # destinatario final
    source_email = os.environ.get("fernandopunales@gmail.com")        # remitente (debe estar verificado)
    if not source_email:
        return {"statusCode": 500, "body": "fernandopunales@gmail.com no configurado"}

    subject = "🚀 Nuevo Deploy Realizado"
    body_text = "Se realizó correctamente un nuevo deploy."

    try:
        resp = ses.send_email(
            Source=source_email,
            Destination={"ToAddresses": [to_email]},
            Message={
                "Subject": {"Data": subject},
                "Body": {"Text": {"Data": body_text}}
            }
        )
    except ClientError as e:
        # loguea el error en CloudWatch (CloudWatch lo recoge automáticamente)
        print("SES error:", e.response.get("Error", {}).get("Message"))
        return {"statusCode": 500, "body": f"Error enviando email: {e}"}

    return {"statusCode": 200, "body": "Notificación enviada correctamente."}
