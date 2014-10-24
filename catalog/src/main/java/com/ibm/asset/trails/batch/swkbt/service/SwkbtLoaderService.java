package com.ibm.asset.trails.batch.swkbt.service;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

public interface SwkbtLoaderService<E> {

	public void batchUpdate(List<? extends E> items)
			throws IllegalArgumentException, SecurityException,
			IllegalAccessException, InvocationTargetException,
			NoSuchMethodException;

}
