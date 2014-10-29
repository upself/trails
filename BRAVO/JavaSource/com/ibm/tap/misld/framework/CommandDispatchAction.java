package com.ibm.tap.misld.framework;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

public class CommandDispatchAction
        extends Action {

    /**
     * The Class instance of this <code>DispatchAction</code> class.
     */
    protected Class                   clazz              = this.getClass();

    /**
     * Commons Logging instance.
     */
    protected static Log              log                = LogFactory
                                                                 .getLog(CommandDispatchAction.class);

    /**
     * The default methodName to be used if no command is found.
     */
    protected static String           DEFAULT_METHODNAME = "failure";

    /**
     * The message resources for this package.
     */
    protected static MessageResources messages           = MessageResources
                                                                 .getMessageResources("org.apache.struts.actions.LocalStrings");

    /**
     * The set of Method objects we have introspected for this class, keyed by
     * method name. This collection is populated as different methods are
     * called, so that introspection needs to occur only once per method name.
     */
    protected HashMap                 methods            = new HashMap();

    /**
     * The set of argument type classes for the reflected method call. These are
     * the same for all calls, so calculate them only once.
     */
    protected Class[]                 types              = {
            ActionMapping.class, ActionForm.class, HttpServletRequest.class,
            HttpServletResponse.class                   };

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        ActionForward forward = null;

        // Get the method's name. This could be overridden in subclasses.
        String methodName = getMethodName(mapping, form, request, response);

        // validation on the methodName
        forward = checkSpecialCases(mapping, form, request, response,
                methodName);

        if (forward == null) {
            Method method = getMethod(mapping, form, request, response,
                    methodName);
            forward = dispatchMethod(mapping, form, request, response, method);
        }
        return (forward);
    }

    public ActionForward checkSpecialCases(ActionMapping mapping,
            ActionForm form, HttpServletRequest request,
            HttpServletResponse response, String methodName) throws Exception {

        ActionForward forward = null;
        // Make sure we have a valid method name to call.
        // This may be null if the user hacks the query string.
        if (methodName == null) {
            // default implementation throws ServletException
            forward = unspecified(mapping, form, request, response);
        }

        // Prevent recursive calls
        if ("execute".equals(methodName) || "perform".equals(methodName)) {
            String message = messages.getMessage("dispatch.recursive", mapping
                    .getPath());

            log.error(message);
            throw new ServletException(message);
        }

        return forward;
    }

    /**
     * Method which is dispatched to when getMethodName does not find a
     * methodName. Subclasses of <code>CommandDispatchAction</code> should
     * override this method if they wish to provide default behavior different
     * than throwing a ServletException.
     */
    protected ActionForward unspecified(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String message = messages.getMessage("dispatch.parameter", mapping
                .getPath(), mapping.getParameter());

        log.error(message);

        throw new ServletException(message);
    }

    protected Method getMethod(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response,
            String methodName) throws Exception {
        // Identify the method object to be dispatched to

        synchronized (methods) {
            Method method = (Method) methods.get(methodName);
            if (method == null) {
                method = clazz.getMethod(methodName, types);
                methods.put(methodName, method);
            }
            return (method);
        }
    }

    protected ActionForward dispatchMethod(ActionMapping mapping,
            ActionForm form, HttpServletRequest request,
            HttpServletResponse response, Method method) throws Exception {

        ActionForward forward = null;
        try {
            Object args[] = { mapping, form, request, response };
            forward = (ActionForward) method.invoke(this, args);

        }
        catch (ClassCastException e) {
            String message = messages.getMessage("dispatch.return", mapping
                    .getPath(), method.getName());
            log.error(message, e);
            throw e;

        }
        catch (IllegalAccessException e) {
            String message = messages.getMessage("dispatch.error", mapping
                    .getPath(), method.getName());
            log.error(message, e);
            throw e;

        }
        catch (InvocationTargetException e) {
            // Rethrow the target exception if possible so that the
            // exception handling machinery can deal with it
            Throwable t = e.getTargetException();
            if (t instanceof Exception) {
                throw ((Exception) t);
            }
            else {
                String message = messages.getMessage("dispatch.error", mapping
                        .getPath(), method.getName());
                log.error(message, e);
                throw new ServletException(t);
            }
        }

        // Return the ActionForward instance
        return (forward);
    }

    /**
     * Returns the method name, found using the form's command. If html:cancel
     * was used, the method name of "cancel" is returned.
     * 
     * @param mapping
     *            The ActionMapping used to select this instance
     * @param form
     *            The ActionForm bean for this request
     * @param request
     *            The HTTP request we are processing
     * @param response
     *            The HTTP response we are creating
     * 
     * @return The method's name.
     */
    protected String getMethodName(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        // Identify the method name to be dispatched to.
        // dispatchMethod() will call unspecified() if name is null

        String methodName = null;

        if (isCancelled(request)) {
            methodName = "cancel";
        }
        else {
            if (form instanceof CommandDispatchForm) {
                CommandDispatchForm commandForm = (CommandDispatchForm) form;
                methodName = commandForm.getMethod();
            }
        }

        return (methodName);
    }

    /**
     * Introspect the current class to identify a method of the specified name
     * that accepts the same parameter types as the <code>execute</code>
     * method does.
     * 
     * @param name
     *            Name of the method to be introspected
     * 
     * @exception NoSuchMethodException
     *                if no such method can be found
     */
    protected Method getMethod(String methodName) throws NoSuchMethodException {

        synchronized (methods) {
            Method method = (Method) methods.get(methodName);
            if (method == null) {
                method = clazz.getMethod(methodName, types);
                methods.put(methodName, method);
            }
            return (method);
        }

    }

    /**
     * The default forward has the same name as the command entered.
     */
    protected ActionForward getMethodForward(ActionMapping mapping,
            ActionForm form, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        return mapping.findForward(getMethodName(mapping, form, request,
                response));
    }

    /**
     * Method which is dispatched to when the request is a cancel button submit.
     * Subclasses of <code>CommandDispatchAction</code> should override this
     * method if they wish to provide default behavior different than returning
     * a "cancel" ActionForward.
     */
    public ActionForward cancel(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        return getMethodForward(mapping, form, request, response);
    }

    /**
     * Method which is dispatched to when the request is a command of "back".
     * Subclasses of <code>CommandDispatchAction</code> should override this
     * method if they wish to provide default behavior different than returning
     * a "back" ActionForward.
     */
    public ActionForward back(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        return getMethodForward(mapping, form, request, response);
    }
}

