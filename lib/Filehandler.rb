require 'fileutils'
class Filehandler
  FILE_ROUTE = Dir.pwd+'/posts.txt'
  def save_post(title,comment)
    File.open(FILE_ROUTE, 'a+') do
    |f| f.write("Inicio de Post")
      	f.write("\n"+"Title:" + title + "\n" )
      	f.write( comment + "\n")
        f.write((Time.now).inspect + "\n")
      	f.write("Fin de Post" + "\n")
    end 
  end
 
  def get_posts_title
    titles=[]
    File.open(FILE_ROUTE,'r').each_line do |line|
      compare_line(line,titles)
    end
    return titles
  end

  def compare_line(line,titles)
    if line.include? "Title:"
      titles.push(line)
    end
  end

  def return_post(index)
    line = get_line_number_start_post(index)
    post = []
    post[0] = IO.readlines(FILE_ROUTE)[line].to_s
    more_than_a_line_comment(line,post)
  end

  def find_line(title)
    File.open(FILE_ROUTE,'r') do |file|
      file.readlines.each_with_index do |line,index|
        return index if line.include? title
      end 
    end
  end

  def more_than_a_line_comment(line,post)
   counter = 0
    while (!(IO.readlines(FILE_ROUTE)[line + counter].to_s).include? "Fin de Post")
      post[counter] = IO.readlines(FILE_ROUTE)[line + counter].to_s
      counter += 1
    end
    return post
  end

  def delete_post(post_number)
    line_in_file = get_line_number_start_post(post_number) - 1
    end_line = get_end_of_post(line_in_file)
    in_line = 0
    line_counter= IO.readlines(FILE_ROUTE).count
    File.open(Dir.pwd+'/posts.txt.tmp','w') do |file2|
      while(line_counter >= in_line)
       unless((in_line >= line_in_file) && (in_line <= end_line))
          file2.write(IO.readlines(FILE_ROUTE)[in_line].to_s)
       end
        in_line += 1
      end
    end
    FileUtils.mv Dir.pwd+'/posts.txt.tmp',FILE_ROUTE
  end
  
  def get_line_number_start_post(post_number)
    titles = []
    titles = get_posts_title
    line = find_line(titles[post_number - 1])
    return line
  end

  def get_end_of_post(start_line)
    while(start_line <= IO.readlines(FILE_ROUTE).count)
       if ((IO.readlines(FILE_ROUTE)[start_line].to_s).include? "Fin de Post")
         return start_line
       end
       start_line +=1
    end
    return start_line
  end
end
