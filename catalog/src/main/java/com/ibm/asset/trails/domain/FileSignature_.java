package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.SignatureOperatorType;

@StaticMetamodel(FileSignature.class)
public class FileSignature_ extends Signature_ {
	public static volatile SetAttribute<FileSignature, File> files;
	public static volatile SingularAttribute<FileSignature, SignatureOperatorType> operator;
	public static volatile SingularAttribute<FileSignature, FileSignatureScopeEnum> scope;
}
