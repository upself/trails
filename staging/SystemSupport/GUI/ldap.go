package main

import (
//    "fmt"
    "strings"
    "log"
    "os/exec"
)

func ldapCheck(user string, pass string) bool {
    //fmt.Println("nasel")
    out, err := exec.Command("/bin/bash", "/opt/SupportGui/ldapauth.sh",user,pass).Output()
    //fmt.Println("pustil")
    if err != nil {
        log.Fatal(err)
    }
    //fmt.Printf("output is %s\n", out)
    sout := strings.TrimSpace(string(out))
 //   suser := strings.TrimSpace(user)
    if sout == user {
        return true
    }
    //fmt.Println(":::",suser,":::")
    //fmt.Println(":::",sout,":::")
    return false
}



