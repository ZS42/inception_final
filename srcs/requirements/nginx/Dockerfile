FROM alpine:3.18

RUN	apk update && apk upgrade && apk add --no-cache nginx

COPY ./requirements/nginx/conf/nginx.conf /etc/nginx/http.d/nginx.conf

RUN apk update && apk add --no-cache wget curl openssl

RUN mkdir -p /etc/nginx/ssl

# see below
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
              -out /etc/nginx/ssl/zsyyida.crt \
			  -keyout /etc/nginx/ssl/zsyyida.key \
			  -subj "/C=AE/ST=AbuDhabi/L=AbuDhabi/O=42 School/OU=student/CN=zsyyida.42.fr"

RUN chmod 644 /etc/nginx/http.d/nginx.conf

RUN chown -R nginx:nginx /etc/nginx/http.d

RUN chown -R nginx:nginx /etc/nginx/ssl

#r for all only
RUN chmod 600 /etc/nginx/ssl/zsyyida.key

#rw for user r for others
RUN chmod 644 /etc/nginx/ssl/zsyyida.crt

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

#The core functionality uses the openssl command to generate a new key-certificate pair:
#req: This subcommand tells OpenSSL to create a certificate signing request (CSR).
#-newkey rsa:4096: Creates a new RSA private key with a key size of 4096 bits (considered secure for current standards).
#-x509: Creates a self-signed certificate (not recommended for production use due to security concerns).
#-sha256: Uses the SHA-256 hashing algorithm for improved security over older algorithms like MD5.
#-days 365: Sets the certificate validity period to 365 days (one year).
#-nodes: Generates a key without a passphrase (not recommended for production due to security risks). This makes the key easier to use but less secure.
#-out /etc/ssl/zsyyida.crt: Specifies the output filename for the certificate (zsyyida.crt).
#-keyout /etc/ssl/zsyyida.key: Specifies the output filename for the private key (zsyyida.key).
#-subj "/C=AE/ST=AbuDhabi/L=AbuDhabi/O=42 School/OU=zsyyida/CN=zsyyida/": Defines the subject information for the certificate. This includes:
#C: Country Code (here, "AE" for United Arab Emirates)
#ST: State/Province (here, "AbuDhabi")
#L: Locality (here, "AbuDhabi")
#O: Organization (here, "42 School")
#OU: Organizational Unit (here, "zsyyida")
#CN: Common Name (here, "zsyyida.42.fr") - This should ideally be your actual domain name for a production environment.
