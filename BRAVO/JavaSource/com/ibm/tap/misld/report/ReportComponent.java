package com.ibm.tap.misld.report;

public class ReportComponent {

    public String componentName;

    public Object value;

    public String getComponentName() {
        return componentName;
    }

    public Object getValue() {
        return value;
    }

    public void setComponentName(String componentName) {
        this.componentName = componentName;
    }

    public void setValue(Object value) {
        this.value = value;
    }
}