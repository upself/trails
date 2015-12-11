package main

import (
    "log"
    "net/http"
)

func main() {


    // private views
    http.HandleFunc("/operationGUI", guiHandler)
    http.HandleFunc("/shost", shostHandler)
    http.HandleFunc("/queryqueue.pl", queryHandler)

    log.Fatal(http.ListenAndServe(":8666", nil))
}

