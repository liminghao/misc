#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#include <iostream>
#include <string>
#include <map>
#include <set>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "qconf_zk.h"

void usage()
{
	printf("Usage: \n");
	printf("n: node \n");
	printf("s: service \n");
	printf("g: get all service \n");
	printf("i: get all service detail \n");
	printf("u: service up \n");
	printf("d: service down \n");
	printf("a: add service \n");
	printf("r: rm service \n");
	printf("c: clear all service \n");
}

int main(int argc, char **argv)
{
	std::string host = "10.10.101.94:2181";

	int fd = open("./qconf_client.err", O_RDWR|O_CREAT|O_TRUNC);
	if (fd == -1) {
		perror("open ./qconf_client.err error");
		exit(1);
	}

	QConfZK qconfZk;
	if(QCONF_OK != qconfZk.zk_init(host))
	{
		printf("zk_init error \n");
		exit(1);
	}

	dup2(fd, STDERR_FILENO);

	std::string node, service;
	std::set<std::string> servs;
	std::map<std::string, char> servs_detail;
	
	if (argc == 1) {
		usage();
	}

	int ch, ret;  
	opterr = 0;  
	while ((ch = getopt(argc, argv,"gis:n:udarch")) != -1)  
	{  
		switch(ch)  
		{
			case 'h':
				usage();
				exit(0);
	
			case 'n':
				node = optarg;
				break;
	
			case 's':
				service = optarg;
				break;

			case 'g':
				ret = qconfZk.zk_services_get(node, servs);
				if (ret != QCONF_OK) {
					printf("zk_services_get failed, ret = %d\n", ret);
					exit(1);
				} else {
					std::set<std::string>::iterator it;
					for(it = servs.begin(); it != servs.end(); it++) {
						printf("%s\n", (*it).c_str());
					}
				}

				exit(0);

			case 'i':
				ret = qconfZk.zk_services_get_with_status(node, servs_detail);
				if (ret != QCONF_OK) {
					printf("zk_services_get_with_status failed, ret = %d\n", ret);
					exit(1);
				} else {
					std::map<std::string, char>::iterator it;
					for(it = servs_detail.begin(); it != servs_detail.end(); it++) {
						//std::cout << it->first << " " << it->second;
						printf("%s [status:%d]\n", (it->first).c_str(), it->second);
					}
				}

				exit(0);

			
			case 'd':
				ret = qconfZk.zk_service_offline(node, service);
				if (ret != QCONF_OK) {
					printf("zk_service_offline failed, ret = %d\n", ret);
					exit(1);
				} else {
					printf("zk_service_offline success! \n");
				}

				exit(0);  

			case 'u':
				ret = qconfZk.zk_service_up(node, service);
				if (ret != QCONF_OK) {
					printf("zk_service_up failed, ret = %d\n", ret);
					exit(1);
				} else {
					printf("zk_service_up success! \n");
				}

				exit(0);  

			case 'a':
				ret = qconfZk.zk_service_add(node, service, STATUS_UP);
				if (ret != QCONF_OK) {
					printf("zk_service_add failed, ret = %d\n", ret);
					exit(1);
				} else {
					printf("zk_service_add success! \n");
				}

				exit(0);  

			case 'r':
				ret = qconfZk.zk_service_delete(node, service);
				if (ret != QCONF_OK) {
					printf("zk_service_delete failed, ret = %d\n", ret);
					exit(1);
				} else {
					printf("zk_service_delete success! \n");
				}

				exit(0);  

			case 'c':
				ret = qconfZk.zk_service_clear(node);
				if (ret != QCONF_OK) {
					printf("zk_service_clear failed, ret = %d\n", ret);
					exit(1);
				} else {
					printf("zk_service_clear success! \n");
				}

				exit(0);  

			default: 
				usage(); 
		}  
	}  

	return 0;
}
