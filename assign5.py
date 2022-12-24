import nltk
nltk.download('maxent_ne_chunker')
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')
nltk.download('words')
nltk.download('wordnet')
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
from nltk.tokenize import sent_tokenize
from nltk.stem import WordNetLemmatizer


input_string = input("Hey user, Please introduce yourself and tell your interests.\n")
# input_string = "I am ashita. I am studying in cse branch. I am interested in software development and ai."

def get_name(sent):
  inp_str = nltk.ne_chunk(nltk.pos_tag(sent))
  ext_name = "none"
  for i in inp_str:
    if(i[1]=='RB'):
      ext_name = i[0]
      return ext_name
  return ext_name

def get_branch(sent):
  inp_str = nltk.ne_chunk(nltk.pos_tag(sent))
  ext_branch=None
  for i in inp_str:
    if(i[1]=='NN'):
      ext_branch = i[0]
      return ext_branch
  return ext_branch

def get_choices(sent):
  inp_str = nltk.ne_chunk(nltk.pos_tag(sent))
  choice1= None
  choice2= None
  for index,word in enumerate(inp_str):
    if word[1] == 'IN':
        choice1 = inp_str[index+1][0].lower()
    if word[1] == 'CC':
        choice2 = inp_str[index+1][0].lower()
        return choice1,choice2
  return choice1,choice2

  
sent_tok = nltk.sent_tokenize(input_string)
# to see tags with each word in each sentence.
for sent in sent_tok:
	 print(nltk.pos_tag(nltk.word_tokenize(sent)))
# get each sentence
word_list = []
for i in sent_tok:
  word_list.append(word_tokenize(i))

print(word_list)



name = get_name(word_list[0])
branch = get_branch(word_list[1])

print(name,branch)

#Open facts.pl file to store
f = open("facts.pl", 'w')

f.write("ask_name(")
f.write(name)
f.write(").\n")



f.write("ask_branch(")
f.write(branch)
f.write(").\n")


interest_mappings = {
    "datascience":'1',
    "ai":'2',
    "design":'3',
    "network security":'4',
    "social sciences":'5',
    "software devlopment":'6'
}

choice1,choice2  = get_choices(word_list[2])
print(choice1,choice2)

# map the interests with the corresponding values
for key in interest_mappings:
    if key.find(choice1) >=0:
        print(interest_mappings[key])
        f.write("ask_choice(")
        f.write(interest_mappings[key])
        f.write(").\n")

    if key.find(choice2) >=0:
        print(interest_mappings[key])
        f.write("ask_choice2(")
        f.write(interest_mappings[key])
        f.write(").\n")



#Asking for minors.
print("Hey {}, few questions to answers to recommend better!!".format(name))
inp1 = input("Do you want to pursue minor in Entrepreneurship, Economics, Computational Biology (y/n)?")
f.write("ask_minor(")
f.write(inp1)
f.write(").\n")
if inp1 == 'y':
    inp2 = input("enter the field you want your minors in:-Entrepreneurship, Economics, Computational Biology (ent/eco/bio) ??")
    f.write("ask_subminor(")
    f.write(inp2)
    f.write(").\n")



#Asking for btp
inp3 = input("Are you interested in doing btp?(y/n)")
f.write("ask_btp(")
f.write(inp3)
f.write(").\n")


f.close()
