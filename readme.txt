1) Start Eureka server (port 8761)
2) Start demo (port 8080 first instance) -> register on Eureka server
3) Start demo (port 8081 first instance) -> register on Eureka server
4) Call Eureka web -> http://localhost:8761

5) Check the demo service name registered in Eureka calling http://localhost:8761 

6) Call DEMO service using gataway port -> http://localhost:8765/DEMO/api/pingctrl/ping

Multiple call with infinitive loop and 5 seconds of delay:
----------------------------------------------------------
1) open dos shell
2) write -> for /l %g in () do @(curl http://localhost:8765/DEMO/api/pingctrl/ping & timeout /t 5)
