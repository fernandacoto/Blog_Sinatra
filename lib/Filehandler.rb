require 'fileutils'
class Filehandler

  def save_post(title,comment)
    File.open("posts.txt", 'a+') do
    |f| f.write("Inicio de Post")
      	f.write("\n"+"Title:" + title + "\n" )
      	f.write( comment + "\n")
        f.write((Time.now).inspect + "\n")
      	f.write("Fin de Post" + "\n")
    end 
  end
  
  def save_and_delete_post(title,comment,post_number)
    save_post(title,comment)
    delete_post(post_number)
  end

  def get_posts_title
    titles=[]
    File.open(Dir.pwd+'/posts.txt','r').each_line do |line|
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
    post[0] = IO.readlines(Dir.pwd+'/posts.txt')[line].to_s
    more_than_a_line_comment(line,post)
  end

  def buscar_linea(title)
    contador = 0
    while(contador <= IO.readlines(Dir.pwd+'/posts.txt').count)
       if ((IO.readlines(Dir.pwd+'/posts.txt')[contador].to_s).include? title)
         return contador
       end
       contador +=1
    end
  end

  def more_than_a_line_comment(line,post)
   contador = 0
    while (!(IO.readlines(Dir.pwd+'/posts.txt')[line + contador].to_s).include? "Fin de Post")
      post[contador] = IO.readlines(Dir.pwd+'/posts.txt')[line + contador].to_s
      contador += 1
    end
    return post
  end
  #####From here I need to make changes
  def edit_post(index)
    final_post=[]
    post=return_post(index)
    contador = 0 
    while(contador < post.length)
      final_post[contador] = post[contador].chomp
      contador +=1
    end
    return final_post
  end

  def delete_post(post_number)
    line_in_file = get_line_number_start_post(post_number) - 1
    end_line = get_end_of_post(line_in_file)
    in_line = 0
    line_counter= IO.readlines(Dir.pwd+'/posts.txt').count
    File.open(Dir.pwd+'/posts.txt.tmp','w') do |file2|
      while(line_counter >= in_line)
       if((in_line >= line_in_file)&&(in_line <= end_line))
       else 
          file2.write(IO.readlines(Dir.pwd+'/posts.txt')[in_line].to_s)
       end
        in_line += 1
      end
    end
    FileUtils.mv Dir.pwd+'/posts.txt.tmp',Dir.pwd+'/posts.txt'
  end
  
  def get_line_number_start_post(post_number)
    titles = []
    titles = get_posts_title
    line = buscar_linea(titles[post_number - 1])
    return line
  end

  def get_end_of_post(start_line)
    while(start_line <= IO.readlines(Dir.pwd+'/posts.txt').count)
       if ((IO.readlines(Dir.pwd+'/posts.txt')[start_line].to_s).include? "Fin de Post")
         return start_line
       end
       start_line +=1
    end
    return start_line
  end
end
#prueba = Filehandler.new()
#prueba.delete_post(1)
