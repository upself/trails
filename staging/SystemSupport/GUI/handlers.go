package main

import (
"io"
"net/http"
"fmt"
"time"
"strings"
"os/exec"
b64 "encoding/base64"
)

func shostHandler(w http.ResponseWriter, r *http.Request) {

	var formusername string = ""
	var formpassword string = ""
	var username string = ""
	var password string = ""
	var login bool = true
	const htmlHeader string= `<html><head></head><body>`
	const htmlFooter string= ` </body></html>`
	const htmlInvalid string= `INVALID username/password`
	const LoginScreen string = `<form method="post" action="/operationGUI">
	<input type="text" name="username"required>
	<input type="password" name="password" required>
	<input type="submit" value="Login"></form>`
	r.ParseForm() 
	passCookie , _ := r.Cookie("password")
	nameCookie , _:= r.Cookie("username")
	formusername = r.FormValue("username")
	formpassword = r.FormValue("password")
	var data string;
	for k, v := range r.Form {
		data += fmt.Sprint(k +"="+strings.Join(v, ""))
       	// data += fmt.Sprint("val:", strings.Join(v, ""))
	}
//	fmt.Println("data::",data)


		if len(formusername) < 1  && nameCookie == nil {  // no auth
			login = false;
		} else if len(formusername) > 0{
			username = formusername
			password = formpassword
		} else { // we already saw the page
			usr,_  :=  b64.StdEncoding.DecodeString(nameCookie.Value)
			pwd,_  := b64.StdEncoding.DecodeString(passCookie.Value)
			username = string(usr)
			password = string(pwd)
		//	fmt.Println("In cookie handler")
		}
		//fmt.Println(":::",username,":::")
		//fmt.Println(":::",password,":::")

	  //      if ldapCheck("uid=Z79543668,c=cz,ou=bluepages,o=ibm.com","overmind222"){
		if (login && username != "" && password != "" && ldapCheck(username,password))  {
			cusername  :=  b64.StdEncoding.EncodeToString([]byte(username))
			cpassword  := b64.StdEncoding.EncodeToString([]byte(password))
			expiration := time.Now().Add( 24*time.Hour)
			cookie := http.Cookie{Name: "username", Value: cusername, Expires: expiration}
			http.SetCookie(w, &cookie)
			cookie2 := http.Cookie{Name: "password", Value: cpassword, Expires: expiration}
			http.SetCookie(w, &cookie2)
			out, err := exec.Command("/opt/SupportGui/shost.pl",username,data).CombinedOutput()
			if err != nil {
			}


			io.WriteString(w, string(out) )
		} else {
			io.WriteString(w, htmlHeader) 
			if login {
				io.WriteString(w, htmlInvalid)
			}        
			io.WriteString(w, LoginScreen) 
			io.WriteString(w, htmlFooter) 
		}
	}

	func guiHandler(w http.ResponseWriter, r *http.Request) {

		var formusername string = ""
		var formpassword string = ""
		var username string = ""
		var password string = ""
		var login bool = true
		const htmlHeader string= `<html><head></head><body>`
		const htmlFooter string= ` </body></html>`
		const htmlInvalid string= `INVALID username/password`
		const LoginScreen string = `<form method="post" action="/operationGUI">
		<input type="text" name="username"required>
		<input type="password" name="password" required>
		<input type="submit" value="Login"></form>`
		r.ParseForm() 
		passCookie , _ := r.Cookie("password")
		nameCookie , _:= r.Cookie("username")
		formusername = r.FormValue("username")
		formpassword = r.FormValue("password")
		var data string;
		var first bool = true;
		for k, v := range r.Form {
			if !first{
				data += fmt.Sprint("&")

			}
			data += fmt.Sprint(k +"="+strings.Join(v, ""))
			first = false;
		}

		if len(formusername) < 1  && nameCookie == nil {  // no auth
			login = false;
		} else if len(formusername) > 0{
			username = formusername
			password = formpassword
		} else { // we already saw the page
			usr,_  :=  b64.StdEncoding.DecodeString(nameCookie.Value)
			pwd,_  := b64.StdEncoding.DecodeString(passCookie.Value)
			username = string(usr)
			password = string(pwd)
			//fmt.Println("In cookie handler")
		}
//		fmt.Println(":::",username,":::")
//		fmt.Println(":::",password,":::")
//		fmt.Println(":::",data,":::")

	  //      if ldapCheck("uid=Z79543668,c=cz,ou=bluepages,o=ibm.com","overmind222"){
		if (login && username != "" && password != "" && ldapCheck(username,password))  {
			cusername  :=  b64.StdEncoding.EncodeToString([]byte(username))
			cpassword  := b64.StdEncoding.EncodeToString([]byte(password))
			expiration := time.Now().Add( 24*time.Hour)
			cookie := http.Cookie{Name: "username", Value: cusername, Expires: expiration}
			http.SetCookie(w, &cookie)
			cookie2 := http.Cookie{Name: "password", Value: cpassword, Expires: expiration}
			http.SetCookie(w, &cookie2)


			out, err := exec.Command("/opt/SupportGui/operationGUI.pl",username,data).CombinedOutput()
			if err != nil {
			}
			io.WriteString(w, string(out) )
		} else {
			io.WriteString(w, htmlHeader) 
			if login {
				io.WriteString(w, htmlInvalid)
			}        
			io.WriteString(w, LoginScreen) 
			io.WriteString(w, htmlFooter) 
		}
	}


    func queryHandler(w http.ResponseWriter, r *http.Request) {

        var formusername string = ""
        var formpassword string = ""
        var username string = ""
        var password string = ""
        var login bool = true
        const htmlHeader string= `<html><head></head><body>`
        const htmlFooter string= ` </body></html>`
        const htmlInvalid string= `INVALID username/password`
        const LoginScreen string = `<form method="post" action="/operationGUI">
        <input type="text" name="username"required>
        <input type="password" name="password" required>
        <input type="submit" value="Login"></form>`
        r.ParseForm()
        passCookie , _ := r.Cookie("password")
        nameCookie , _:= r.Cookie("username")
        formusername = r.FormValue("username")
        formpassword = r.FormValue("password")
        var data string;
        var first bool = true;
        for k, v := range r.Form {
            if !first{
                data += fmt.Sprint("&")

            }
            data += fmt.Sprint(k +"="+strings.Join(v, ""))
            first = false;
        }

        if len(formusername) < 1  && nameCookie == nil {  // no auth
            login = false;
        } else if len(formusername) > 0{
            username = formusername
            password = formpassword
        } else { // we already saw the page
            usr,_  :=  b64.StdEncoding.DecodeString(nameCookie.Value)
            pwd,_  := b64.StdEncoding.DecodeString(passCookie.Value)
            username = string(usr)
            password = string(pwd)
      //      fmt.Println("In cookie handler")
        }
//        fmt.Println(":::",username,":::")
 //       fmt.Println(":::",password,":::")
  //      fmt.Println(":::",data,":::")

      //      if ldapCheck("uid=Z79543668,c=cz,ou=bluepages,o=ibm.com","overmind222"){
        if (login && username != "" && password != "" && ldapCheck(username,password))  {
            cusername  :=  b64.StdEncoding.EncodeToString([]byte(username))
            cpassword  := b64.StdEncoding.EncodeToString([]byte(password))
            expiration := time.Now().Add( 24*time.Hour)
            cookie := http.Cookie{Name: "username", Value: cusername, Expires: expiration}
            http.SetCookie(w, &cookie)
            cookie2 := http.Cookie{Name: "password", Value: cpassword, Expires: expiration}
            http.SetCookie(w, &cookie2)


            out, err := exec.Command("/opt/SupportGui/queryqueue.pl",username,data).CombinedOutput()
            if err != nil {
            }
            io.WriteString(w, string(out) )
        } else {
            io.WriteString(w, htmlHeader)
            if login {
                io.WriteString(w, htmlInvalid)
            }
            io.WriteString(w, LoginScreen)
            io.WriteString(w, htmlFooter)
        }
    }

