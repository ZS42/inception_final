FROM alpine:3.18

ARG DB_NAME \
    DB_USER \
    DB_PASS \
	DB_ROOT

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
	#The tee command sends the output of echo to a file
    #creates a configuration file named docker.cnf inside the /etc/my.cnf.d directory. The configuration snippet defines the following:
    #[mysqld]: Defines a section for MariaDB configuration options.
    #skip-host-cache: Disables hostname caching for improved performance.
    #skip-name-resolve: Disables hostname resolution for faster startup.
    #bind-address=0.0.0.0: Allows connections from any host (not recommended for production due to security concerns).
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    #sed is a unix command line utility fro text processing. -i instructs sed to modify the original file directly ie not just display but save modification
    # s stands for substitute so sed will search for pattern "skip-networking" and replace it with "skip-networking=0" thus enabling networking. Default keeps it disabled for security reasons
    #g is flag for global modifier and tells sed to replace all occurences
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

#This line initializes the MariaDB data directory (/var/lib/mysql) using the mysql_install_db tool. It specifies the user mysql for this operation.
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

#copies a script named create_db.sh from the requirements/mariadb/conf directory on the host machine to the current directory within the container.
COPY requirements/mariadb/conf/create_db.sh .

# executes the copied script using sh (assuming it's a shell script) and then removes the script from the container after execution.
RUN sh create_db.sh && rm create_db.sh

#setting default user to mysql
USER mysql

#runs the MariaDB server executable (/usr/bin/mysqld) as default command
#--skip-log-error tells the server to skip writing error logs to the standard error stream, potentially reducing disk usage but also making troubleshooting more difficult.
CMD ["/usr/bin/mysqld", "--skip-log-error"]