/**
 * 
 */
package com.ibm.trac.chart;

import java.io.IOException;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.data.time.Day;
import org.jfree.data.time.Minute;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import org.jfree.data.xy.XYDataset;

import com.ibm.trac.domain.EffortProgress;
import com.ibm.trac.domain.Sprint;
import com.ibm.trac.service.EffortProgressService;

/**
 * @author zhangyi
 * 
 */
public class DrawLineChart {

	private Sprint sprint;
	private EffortProgressService effortProgressService = new EffortProgressService();

	/**
	 * 
	 */
	public DrawLineChart(Sprint sprint) {
		this.sprint = sprint;
	}

	public JFreeChart draw() throws IOException, ParseException {
		JFreeChart chart = ChartFactory.createTimeSeriesChart(
				this.sprint.getName(), "Date", "Effort", getDataSet(), true,
				true, false);

		return chart;

	}

	private XYDataset getDataSet() throws ParseException {
		TimeSeries planSerie = new TimeSeries("Plan");
		TimeSeries actualSerie = new TimeSeries("Actual");

		int devDuration = 0;
		float totalEstimateEffort = this.sprint.getEffort();

		Date startDate = sprint.getStart();
		Date endDate = sprint.getEnd();

		if (startDate.after(endDate)) {
			Date temp = endDate;
			startDate = endDate;
			endDate = temp;
		}

		Date tempDate = (Date) startDate.clone();
		Calendar calendar = Calendar.getInstance();

		while (!tempDate.equals(endDate)) {
			calendar.setTime(tempDate);
			calendar.add(Calendar.DATE, 1);
			tempDate = calendar.getTime();
			devDuration++;
		}

		Date[] label = new Date[devDuration];
		float[] values = new float[devDuration];

		float delta = totalEstimateEffort / (devDuration - 1);

		tempDate = (Date) startDate.clone();
		calendar = Calendar.getInstance();

		int i = 0;
		while (i < devDuration) {
			calendar.setTime(tempDate);
			calendar.add(Calendar.DATE, 1);
			tempDate = calendar.getTime();

			label[i] = tempDate;
			values[i] = totalEstimateEffort - delta * i;
			i++;
		}

		for (i = 0; i < label.length; i++) {
			planSerie.add(new Day(label[i]), values[i]);
		}

		List<EffortProgress> epList = effortProgressService
				.loadEfforProgress(this.sprint);

		for (EffortProgress effortProgress : epList) {
			actualSerie.add(new Minute(effortProgress.getTime()),
					effortProgress.getEffort());
		}

		TimeSeriesCollection dataset = new TimeSeriesCollection();
		dataset.addSeries(planSerie);
		dataset.addSeries(actualSerie);

		return dataset;
	}
}
