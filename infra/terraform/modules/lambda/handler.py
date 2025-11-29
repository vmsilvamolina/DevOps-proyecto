import smtplib
import os

def lambda_handler(event, context):
    sender = os.environ["SENDER_EMAIL"]        # tu Gmail
    app_password = os.environ["APP_PASSWORD"]  # contraseña de app
    receiver = "rodrigosilvaromero14@gmail.com"     # destinatario final

    subject = "Infra desplegada correctamente"
    body = "La infraestructura se levantó correctamente con el pipeline."

    message = f"Subject: {subject}\n\n{body}"

    try:
        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            server.login(sender, app_password)
            server.sendmail(sender, receiver, message)

        return {"statusCode": 200, "body": "Email enviado correctamente."}

    except Exception as e:
        print("Error enviando email:", e)
        return {"statusCode": 500, "body": str(e)}
