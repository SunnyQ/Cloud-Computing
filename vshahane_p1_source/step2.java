import java.io.IOException;
import java.util.*;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapred.*;


public class  step2 {
	 
	public static class Map extends MapReduceBase implements Mapper<LongWritable, Text, Text, Text> {
	    public void map(LongWritable _key, Text _value, OutputCollector<Text, Text> output, Reporter reporter) throws IOException {
	    	String value = _value.toString();
	    	String[] values = value.split("}");
	    	if (values.length > 1) {
	    		output.collect(new Text(values[0]), new Text(values[1].replaceAll("\t","#")));
	    	}
		}

	}
 
	public static class Reduce extends MapReduceBase implements Reducer<Text, Text, Text, Text>{

		public void reduce(Text _key, Iterator<Text> values,
				OutputCollector<Text, Text> output, Reporter reporter) throws IOException {
			String key = _key.toString();
			String dateString = new String();
			String viewsString = new String();
			int totalsum = 0;
			int v1to7 = 0;
			int v8to15 = 0;
			int day_int;
			int trend;
			while (values.hasNext()){
				Text val = (Text) values.next();
				String valc = val.toString();
				String[] vals = valc.split("#");
				if (vals.length > 1) {
				dateString = dateString + vals[0] + ",";
				viewsString = viewsString + vals[1] + ",";
				String day = vals[0].substring(6, 8);
				day_int = Integer.parseInt(day);
				if (day_int <= 7)
					v1to7 += Integer.parseInt(vals[1]);
				else
					v8to15 += Integer.parseInt(vals[1]);
				totalsum += Integer.parseInt(vals[1]);
				}
			}
			if (viewsString.endsWith(",")) {
				dateString = dateString.substring(0, dateString.length() - 1);
			}
			if (viewsString.endsWith(",")) {
				viewsString = viewsString.substring(0, viewsString.length() - 1);
			}
			trend = v8to15 - v1to7;
			output.collect(new Text(key+"\t["+dateString+"]"), new Text("["+viewsString+"]\t"+totalsum+"\t"+trend));
		}
	}
 
    public static void main(String[] args) throws Exception {
        JobConf conf = new JobConf(step2.class);
	    conf.setJobName("wiki-step2");
	
	    conf.setOutputKeyClass(Text.class);
        conf.setOutputValueClass(Text.class);
	    conf.setMapperClass(Map.class);
	    //conf.setCombinerClass(Combine.class);
	    conf.setReducerClass(Reduce.class);
	
	    conf.setInputFormat(TextInputFormat.class);
	    conf.setOutputFormat(TextOutputFormat.class);
	
	    FileInputFormat.setInputPaths(conf, new Path(args[0]));
	    FileOutputFormat.setOutputPath(conf, new Path(args[1]));
	
	    JobClient.runJob(conf);
	}
}