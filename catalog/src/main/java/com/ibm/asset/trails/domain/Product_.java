package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.IPLAType;

@StaticMetamodel(Product.class)
public class Product_ extends SoftwareItem_ {
	public static volatile SetAttribute<Product, Alias> alias;
	public static volatile SingularAttribute<Product, IPLAType> ipla;
	public static volatile SingularAttribute<Product, Boolean> pvu;
	public static volatile SingularAttribute<Product, String> function;
	public static volatile SingularAttribute<Product, Integer> licenseType;
	public static volatile SingularAttribute<Product, Manufacturer> manufacturer;
	public static volatile SingularAttribute<Product, Boolean> subCapacityLicensing;
}
