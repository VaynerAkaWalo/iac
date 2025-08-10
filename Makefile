gen-secret-certs:
	mkdir -p certs
	openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout certs/sealed-secrets.key -out certs/sealed-secrets.crt -subj "/CN=sealed-secret/O=sealed-secret"