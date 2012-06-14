/*  \brief lxi-control
 *         MD included form of the command line program
 *
 *  This is identically the same code as in the command line
 *  utility with as few modifications as possible so the latter can
 *  be used with the expectation that SCPI commands that work with
 *  it will work in the MD.
 *
 */

/*
 * lxi-control - A command line client for controlling LXI devices
 *
 * This application allows the sending of Standard Commands for Programable 
 * Instruments (SCPI).
 *
 * Author: Martin Lund (mgl@doredevelopment.dk)
 *
 * Copyright 2009 DoréDevelopment
 *
 * This program is free software; you can redistribute  it and/or modify it
 * under  the terms of  the GNU General  Public License as published by the
 * Free Software Foundation;  either version 2 of the  License, or (at your
 * option) any later version.
 */

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <sys/file.h>

/* Application configuration */
#define APP_VERSION		"1.0.0"
#define NET_NODELAY	1	// TCP nodelay enabled
#define NET_TIMEOUT	4	// Network timeout in seconds (default)
#define NET_MAX_NODES	256
#define ERR		-1
#define NET_MAX_BUF	1500
#define BROADCAST_ADDR	"255.255.255.255"
#define BROADCAST_PORT	111

/* Status message macros */
#define INFO(format, args...) \
	fprintf (stdout, "" format, ## args)

#define ERROR(format, args...) \
	fprintf (stderr, "Error: " format, ## args)

#define MODE_NORMAL	0
#define MODE_DISCOVERY	1

/* Configuration structure */
static struct {
	char *ip;		/* Instrument IP */
	unsigned int port;	/* Instrument port number */
	char *command;		/* SCPI command */
	int socket;		/* Socket handle */
	int mode;		/* Program mode */
	int timeout;
} config = {			/* Defaults */
	NULL,
	9221,
	NULL,
	0,
	MODE_NORMAL,
	NET_TIMEOUT
};

/* Binary UDP payload which represents GETPORT RPC call */
char rpc_GETPORT_msg[] = {
0x00, 0x00, 0x03, 0xe8, 0x00, 0x00, 0x00, 0x00, 
0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x86, 0xa0, 
0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
0x00, 0x06, 0x07, 0xaf, 0x00, 0x00, 0x00, 0x01, 
0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00 };

/*----------------------------------------------------------------------------*/

void print_help(void)
{
	INFO("Usage: lxi-control [options]\n");
	INFO("\n");
	INFO("Options:\n");
	INFO("--ip       <ip>       Remote device IP\n");
	INFO("--port     <port>     Remote device port (default: %d)\n",
								config.port);
	INFO("--scpi     <command>  SCPI command\n");
	INFO("--timeout  <seconds>  Network timeout (default: %d s)\n",
								config.timeout);
	INFO("--discover            Discover LXI devices on hosts subnet\n");
	INFO("--version             Display version\n");
	INFO("--help                Display help\n");
	INFO("\n");
}

static int parse_options(int argc, char *argv[])
{
	static int c;

	/* Print usage help if no arguments */
	if (argc == 1)
	{
		print_help();
		exit(0);
	}

	while (1)
	{
		static struct option long_options[] =
		{
			{"ip",		required_argument,	0, 'i'},
			{"port",	required_argument,	0, 'p'},
			{"scpi",	required_argument,	0, 's'},
			{"timeout",	no_argument,		0, 't'},
			{"discover",	no_argument,		0, 'd'},
			{"version",	no_argument,		0, 'v'},
			{"help",	no_argument,		0, 'h'},
			{0, 0, 0, 0}
		};
		
		/* getopt_long stores the option index here. */
		int option_index = 0;

		/* Parse argument using getopt_long (no short opts allowed) */
		c = getopt_long (argc, argv, "", long_options, &option_index);

		/* Detect the end of the options. */
		if (c == -1)
			break;

		switch (c)
		{
			case 0:
				/* If this option set a flag, do nothing else now. */
				if (long_options[option_index].flag != 0)
					break;
				INFO("option %s", long_options[option_index].name);
				if (optarg)
					INFO(" with arg %s", optarg);
				INFO("\n");
				break;
			
			case 'i':
				config.ip = optarg;
				break;

			case 'p':
				config.port = atoi(optarg);
				break;

			case 's':
				config.command = optarg;
				break;

			case 'v':
				INFO("lxi-control v%s\n", APP_VERSION);
				exit(0);
				break;

			case 'd':
				config.mode = MODE_DISCOVERY;
				break;

			case 'h':
				print_help();
				exit(0);
				break;

			case '?':
				/* getopt_long already printed an error message. */
				break;

			default:
				ERROR("End of options\n");
				exit(1);
		}
	}

	/* Check that --ip is set */
	if ((config.ip == NULL) && (config.mode == MODE_NORMAL))
	{
		ERROR("Missing option: --ip\n");
		exit(1);
	}

	/* Print any remaining command line arguments (invalid options). */
	if (optind < argc)
	{
		ERROR("%s: unknown arguments: ", argv[0]);
		while (optind < argc)
			ERROR("%s ", argv[optind++]);
		ERROR("\n");
		exit(1);
	}
}

static int disconnect_instrument(void)
{
	/* Close socket */
	if(close(config.socket)==ERR)
	{
		ERROR("Error closing socket\n");
		exit(1);
	}
	
	return 0;
}

static int connect_instrument(void)
{
	int retval = 0;
	struct sockaddr_in recv_addr = { 0 };
	int state_nodelay = NET_NODELAY;
	struct timeval tv;
	
	/* Create socket */
	config.socket = socket(PF_INET,SOCK_STREAM,0);
	
	if(config.socket == ERR)
	{
		ERROR("Error connecting socket\n");
		exit(1);
	}

	/* Set socket options - TCP */
	setsockopt(config.socket, IPPROTO_TCP, TCP_NODELAY,
				(void *)&state_nodelay,sizeof state_nodelay);

	/* Set socket options - timeout */
	tv.tv_sec = config.timeout;
	tv.tv_usec = 0;
	if ((setsockopt(config.socket, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv))) == ERR)
	{
		perror("setsockopt - SO_RCVTIMEO");
		exit(1);
	}

	/* Receivers address */
	memset(&recv_addr,0,sizeof(struct sockaddr_in));
	recv_addr.sin_family=PF_INET;			// IPv4
	recv_addr.sin_port=htons(config.port);
	inet_aton(config.ip, &recv_addr.sin_addr);	// IP Address

	/* Establish TCP connection */
	retval = connect(config.socket,(struct sockaddr *)&recv_addr,
						sizeof(struct sockaddr_in));
	if(retval == ERR)
	{
///		ERROR("Error establishing TCP connection\n"); // FIXME
		return 1;
	}
	return retval;
}

static int send_command(void)
{
	int retval = 0;
	
	/* Add string termination to command */
	config.command[strlen(config.command)] = 0;
	
	/* Send SCPI command */
	retval = send(config.socket,config.command,strlen(config.command)+1,0);
	if (retval == ERR)
	{
		ERROR("Error sending SCPI command\n");
		exit(1);
	}

	return retval;
}

static int receive_response(void)
{
	char buffer[500];
	int length;
	int i, question = 0;
	
	/* Skip receive if no '?' in command */
	for (i=0; i<strlen(config.command);i++)
	{
		if (config.command[i] == '?')
			question=1;
	}
	if (question == 0)
		return 0;
	
	/* Read response */
	if((length=recv(config.socket,&buffer[0],200,0))==ERR)
	{
		ERROR("Error reading response\n");
		exit(1);
	}
	
	/* Add zero character (C string) */
	buffer[length]=0; 
	
	/* Print received data */
	printf("%s",buffer);
	
	return 0;
}

static int discover_instruments(void)
{
	int sockfd;
	struct sockaddr_in send_addr;
	struct sockaddr_in recv_addr;
	int broadcast = 1;
	int count;
	int addrlen;
	char buf[NET_MAX_BUF];
	struct timeval tv;
	struct in_addr ip_list[NET_MAX_NODES];
	int i = 0;
	int j = 0;
	char idn_command[] = "*IDN?";

	INFO("\nDiscovering LXI devices on hosts subnet - please wait...\n");

	/* create a socket */
	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sockfd == -1)
	{
		perror("Socket creation error");
		exit(1);
	}

	/* Set socket options - broadcast */
	if((setsockopt(sockfd, SOL_SOCKET, SO_BROADCAST,
					&broadcast,sizeof (broadcast))) == ERR)
	{
		perror("setsockopt - SO_SOCKET");
		exit(1);
	}
	
	/* Set socket options - timeout */
	tv.tv_sec = config.timeout;
	tv.tv_usec = 0;
	if ((setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv))) == ERR)
	{
		perror("setsockopt - SO_RCVTIMEO");
		exit(1);
	}

	/* Senders address */
	send_addr.sin_family = AF_INET;
	send_addr.sin_addr.s_addr = INADDR_ANY;
	send_addr.sin_port = 0;		// 0 = random sender port

	/* Bind socket to address */
	bind(sockfd, (struct sockaddr*)&send_addr, sizeof(send_addr));

	/* Receivers address */ 
	recv_addr.sin_family = AF_INET;
	recv_addr.sin_addr.s_addr = inet_addr(BROADCAST_ADDR);
	recv_addr.sin_port = htons(BROADCAST_PORT);

	/* Broadcast RPC GETPORT message */
	sendto(sockfd, rpc_GETPORT_msg, sizeof(rpc_GETPORT_msg), 0, 
			(struct sockaddr*)&recv_addr, sizeof(recv_addr));

	addrlen = sizeof(recv_addr);

	/* Go through received responses */
	do {
		count = recvfrom(sockfd, buf, NET_MAX_BUF, 0, 
					(struct sockaddr*)&recv_addr, &addrlen);
		if (count > 0)
		{
			ip_list[i] = recv_addr.sin_addr;
			i++;
		}
	} while (count > 0);

	INFO("\nDiscovered devices:\n");

	/* Request SCPI IDN of responding hosts */
	for (j=0; j<i; j++)
	{
		config.ip = inet_ntoa(ip_list[j]);
		if (connect_instrument() == 0)
		{
			config.command = idn_command;
			
			send_command();
			
			INFO("IP %s  -  ", config.ip);
			
			receive_response();
		
			disconnect_instrument();
		}
	}

	INFO("\n");

	return 0;
}
int lxi_control (int argc, char *argv[])
{
	/* Parse command line options */
	parse_options(argc, argv);
	
	if (config.mode == MODE_DISCOVERY)
	{
		/* Discover instruments IPs via VXI-11 broadcast */
		discover_instruments();
	}
	else
	{
	
		/* Connect instrument */
		connect_instrument();
	
		/* Send command */
		send_command();
	
		/* Read response */
		receive_response();
	
		/* Disconnect instrument */
		disconnect_instrument();
	}
	
	return (0);
}
