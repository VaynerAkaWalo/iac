gen-secret-certs:
	mkdir -p certs
	openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout certs/sealed-secrets/secret.key -out certs/sealed-secrets/secret.crt -subj "/CN=sealed-secret/O=sealed-secret"

seal-tls-secret:
	kubectl create secret tls $(name) \
      --cert=certs/$(name)/secret.crt \
      --key=certs/$(name)/secret.key \
      --dry-run=client -o yaml > kubernetes/secrets/$(name)-plain-secret.yaml; \
   	kubeseal --namespace=$(namespace) --cert=certs/sealed-secrets/secret.crt < kubernetes/secrets/$(name)-plain-secret.yaml > kubernetes/secrets/$(name).yaml; \
   	rm kubernetes/secrets/$(name)-plain-secret.yaml

seal-secret:
		kubectl create secret generic $(name) --from-literal=$(payload) \
          --dry-run=client -o yaml > kubernetes/secrets/$(name)-plain-secret.yaml; \
        kubeseal --namespace=$(namespace) --cert=certs/sealed-secrets/secret.crt < kubernetes/secrets/$(name)-plain-secret.yaml > kubernetes/secrets/$(name).yaml; \
        rm kubernetes/secrets/$(name)-plain-secret.yaml

