#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 17267
#define FILENAME "./uruguay-2023-11.osm.bz2"
#define BUFFER_SIZE 1024

char buffer[BUFFER_SIZE] = {0};

void send_file(int client_socket) {
	FILE *file = fopen(FILENAME, "rb");

	fseek(file, 0, SEEK_END);
	long file_size = ftell(file);
	fseek(file, 0, SEEK_SET);

	printf("File located: %ld bytes\n", file_size);

	sprintf(buffer, "HTTP/1.1 200 OK\r\nContent-Length: %ld\r\n\r\n", file_size);
	send(client_socket, buffer, strlen(buffer), 0);

	printf("HTTP response headers sent\n");

	while (!feof(file)) {
		size_t bytesRead = fread(buffer, 1, BUFFER_SIZE, file);
		send(client_socket, buffer, bytesRead, 0);
	}

	printf("File sent\n");

	fclose(file);
}

int start_server() {
	int server_socket = socket(AF_INET, SOCK_STREAM, 0);

	struct sockaddr_in server_addr;
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
	server_addr.sin_port = htons(PORT);

	(void) bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr));
	listen(server_socket, 5);

	return server_socket;
}


int accept_client(int server_socket) {
	struct sockaddr_in client_addr;
	socklen_t client_len = sizeof(client_addr);

	int client_socket;
	while (1) {
		client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &client_len);
		if (client_socket < 0) {
			perror("Error accepting connection");
			continue;
		} else {
			return client_socket;
		}
	}
}

int main() {
	setbuf(stdout, NULL);
	printf("Server starting\n");

	int server_socket = start_server();

	printf("Server listening on port %d...\n", PORT);

	int client_socket = accept_client(server_socket);

	printf("\n");
	printf("Client connected\n");

	send_file(client_socket);
	shutdown(client_socket, SHUT_WR);
	sleep(1);
	close(client_socket);
	
	printf("\nServer is done ... exiting\n");
	close(server_socket);

	return 0;
}
