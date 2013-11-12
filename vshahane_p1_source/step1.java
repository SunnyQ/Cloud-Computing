import java.io.IOException;
import java.util.*;
import java.lang.Character;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapred.*;


public class  step1 {
	 
	public static class Map extends MapReduceBase implements Mapper<LongWritable, Text, Text, IntWritable> {
	    //public final IntWritable one = new IntWritable(1);
	    public void map(LongWritable key, Text value, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException {
	    	FileSplit fileSplit = (FileSplit)reporter.getInputSplit();
	        String filename = fileSplit.getPath().getName();
	        String[] Tempfilename = filename.split("-");
	    	String TempString = value.toString();
	    	//String NewString = TempString.replaceAll("(\\%)(\\w)(\\w)","_");
	    	String NewString = TempString.replaceAll("(\\%)22","_");
			String[] SingleWikiData = NewString.split(" ");
			//String day = Tempfilename[1].substring(6, 8);
			//int day_int = Integer.parseInt(day);
			if (SingleWikiData.length > 1) {
			  String Title = SingleWikiData[1];
			  //if (day_int <= 15) {
				if (SingleWikiData[0].equalsIgnoreCase("en")) {
					if(!(Title.toLowerCase().startsWith("media")) && !(Title.toLowerCase().startsWith("special")) && !(Title.toLowerCase().startsWith("talk")) && !(Title.toLowerCase().startsWith("user")) && !(Title.toLowerCase().startsWith("user_talk")) && !(Title.toLowerCase().startsWith("project")) && !(Title.toLowerCase().startsWith("project_talk")) && !(Title.toLowerCase().startsWith("file")) && !(Title.toLowerCase().startsWith("file_talk")) && !(Title.toLowerCase().startsWith("mediaWiki")) && !(Title.toLowerCase().startsWith("mediaWiki_talk")) && !(Title.toLowerCase().startsWith("template")) && !(Title.toLowerCase().startsWith("template_talk")) && !(Title.toLowerCase().startsWith("help")) && !(Title.toLowerCase().startsWith("category")) && !(Title.toLowerCase().startsWith("help_talk")) && !(Title.toLowerCase().startsWith("category_talk")) && !(Title.toLowerCase().startsWith("portal")) && !(Title.toLowerCase().startsWith("wikipedia")) && !(Title.toLowerCase().startsWith("wikipedia_talk"))) {
						if (!(Character.isLowerCase(Title.charAt(0)))) {
							if (!(Title.endsWith(".jpg")) && !(Title.endsWith(".gif")) && !(Title.endsWith(".png")) && !(Title.endsWith(".JPG")) && !(Title.endsWith(".GIF")) && !(Title.endsWith(".PNG")) && !(Title.endsWith(".ico")) && !(Title.endsWith(".txt")) && !(Title.endsWith(".ICO")) && !(Title.endsWith(".TXT"))) {
								if (!(Title.matches("404_error")) && !(Title.matches("404_Error")) && !(Title.matches("Main_Page")) && !(Title.matches("Hypertext_Transfer_Protocol")) && !(Title.matches("Favicon.ico")) && !(Title.matches("Search"))) {
									output.collect(new Text(Title+"}"+Tempfilename[1]), new IntWritable(Integer.parseInt(SingleWikiData[2])));
								}
							}
						}
					}
				//}
			  }
			}	
		}

	}
 
	public static class Reduce extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable>{

		public void reduce(Text _key, Iterator<IntWritable> values,
				OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException {
			Text key = _key;
			int frequencyForDay =0;
			while (values.hasNext()) {
				IntWritable value = (IntWritable) values.next();
				frequencyForDay += value.get(); 
			}
			output.collect(key, new IntWritable(frequencyForDay));
		}
	}
 
    public static void main(String[] args) throws Exception {
        JobConf conf = new JobConf(step1.class);
	    conf.setJobName("wiki-step1");
	
	    conf.setOutputKeyClass(Text.class);
        conf.setOutputValueClass(IntWritable.class);
	    conf.setMapperClass(Map.class);
	    conf.setCombinerClass(Reduce.class);
	    conf.setReducerClass(Reduce.class);
	
	    conf.setInputFormat(TextInputFormat.class);
	    conf.setOutputFormat(TextOutputFormat.class);
	
	    FileInputFormat.setInputPaths(conf, new Path(args[0]));
	    FileOutputFormat.setOutputPath(conf, new Path(args[1]));
	
	    JobClient.runJob(conf);
	}
}