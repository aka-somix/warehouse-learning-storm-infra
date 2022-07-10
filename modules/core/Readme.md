### CORE Module

Il modulo core contiene tutte le funzionalità primarie per il funzionamento del progetto e che serviranno ad alimentare tutti gli altri moduli di progetto (potrebbe essere visto come la radice dell'albero delle dipendenze discusso [qui](../Readme.md)). 

Il modulo core varia di progetto in progetto. Essendo in questo caso lo scopo di definire un'API hostata su API Gateway, sicuramente la definizione centrale sarà fatta in questo modulo, lasciando che ognuno dei moduli terminali si occupi solo di estendere questa definizione di infrastruttura aggiungendo il pezzo interessato (e.g. il modulo products aggiunge la parte sulla gestione dei prodotti).

Inoltre, nel modulo core sono anche definiti pezzi di infrastruttura come il bucket per gestire i lambda packages (che quindi non contengono dati utili in quanto tali, bensì configurazioni e package utili ad altri pezzi di infrastruttura).
