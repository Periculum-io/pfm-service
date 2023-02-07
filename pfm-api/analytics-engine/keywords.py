## contains all keywords.

salary_keywords = r"\s+sal\s+|slry.|\s*sal\s*(?:jan|feb|mar|apr|may|jun|july|aug|sep|oct|nov\
                    |dec).*|\s*staff\s*sal.*|\s*(?:jan.*|feb.*|mar.*|apr.*|may.*|jun.*|july.*|aug.*|sep.*|oct.*|nov.*\
                    |dec.*)\s*sal.*|\s*salr.*|\s.allow.*|\s.ibt.*|\s.rem.*|\feder:|net\spay|netpay|\
                    |ippis\s*ncs\s*(?:jan.*|feb.*|mar.*|apr.*|may.*|jun.*|july.*|aug.*|sep.*|oct.*|nov.*\|dec.*)|(?<!13th month)\s+salary\s+(?!advance)"

keywords_to_remove_for_salary = ["loan", "palmcredit", "kwikmoney", "lendigo", "branch", "swiss credit", "reversal",
                                 "cash dep", "888sport", "deposit", "deduct","trfby", "fairmoney", "13th month",
                                 "credit direct", "piggyvest", "disbursement credit", "sporty", "bonus", " renmoney",
                                 "loan repayment", "loan repymt", "loan rpmt", "pos", "merrybet",
                                 "bet\s+", "bill", "salary\s*advance", "reverse", "allowance"]

keywords_to_remove_for_other_income = ["loan", "palmcredit", "kwikmoney", "lendigo", "branch", "swiss\s*credit",
                                       "reversal", "cash\s*dep", "888sport", "deposit", "deduct", "fairmoney",
                                       "credit\s*direct", "piggyvest", "disbursement\s*credit", "sporty", "renmoney",
                                       "loan\s*repayment", "loan\s*repymt", "loan\s*rpmt", "swiss", "renm",
                                       "pos", "merrybet", "bet\s+", "bill\s+", "feder:", "cash\s*advance"]

loan_or_repayment_keywords = r"loan\s+|palmcred\s+|kwikmon\s+|lendig\s*|repaym\s*|repymt\s*|onefi\s+|\s+zedvance\s+|\s+aella\s+|\s+quickcheck\s+|\s+creditville\s+" \
                                     r"|\s+paylater\s+|\s+onepipe\s+|\s+lidya\s+|\s+okash\s+|\s+jumiapay\s+|\s+branch\s+international|\s+pettycash\s+|\s+shecluded\s+|\s+fast\s*credit\s+|\s+devonsley\s+|\s+fast\s*point\s+|\s+swiss\s*credit\s+" \
                                     r"|\s+yes\s*credit\s+|\s+c24\s+|\s+arvo\s+|\s+heat\s*finance\s+|\s+helium\s*health\s+|\s+airopay\s+|\s+meritlend\s+|\s+sycamore\s+|\s+credit\s*express\s+|\s+micro\s*leasing\s+|\s+trakade\s+|\s+pennywise\s+" \
                                     r"|\s+daylight\s+|\s+lsetf\s+|\s+liberty\s*assured\s+|\s+aply\s+|\s+astra\s*polaris\s+|\s+wella\s*health\s+|\s+paraquick\s+|\s+zoeafountain\s+|\s+dlm\s*foundation\s+|\s+mvxchange\s+|\s+rexcredit\s+|\s+seguro\s*housing\s+" \
                                     r"|\s+uwana\s*energy\s+|\s+hoil\s*investment\s+|\s+seap\s*mfi\s+|\s+bridge\s*credit\s+|\s+kt\s*arvid\s+|\s+teller\s*one\s+|\s+loanplus\s+|\s+aaa\s*finance\s+|\s+wallstreet\s+|\s+migo\s+|\s+menacred\s+" \
                                     r"|\s+brass\s*and\s*brooks\s+|\s+kwaba\s+|\s+creditwave\s+|\s+health\s*cred\s+|\s+boman\s+|\s+springboard\s+|\s+kreditfort\s+|\s+capsa\s+|\s+neophath\s+|\s+one\s*grow\s+|\s+blackcopper\s+|\s+borome\s+|\s+cyrus\s+|\s+taylor\s*mayson\s+|\s+fairbridge\s+" \
                                     r"|\s+motion\s*yield\s+|\s+litigy\s+|\s+speedpay\s+|\s+tom\s*x\s+|\s+quickcredit\s+|\s+oritis\s+|\s+go\s*loan\s+|\s+first\s*credit\s+|\s+muster\s+|\s+olly\s+|\s+nextpayday\s+|\s+aspire\s+|\s+aladdin\s+|\s+fination\s+|\s+guava\s+|\s+stephensmith\s+|\s+cs\*advance\s+" \
                                     r"|\s+creditwise\s+|\s+eyowo\s+|\s+sharp\s*credit\s+|\s+surbpoulitan\s+|\s+credit\s*pro\s+|\s+zion\s*tech\s+|\s+lorentz\s+|\s+tangerine\s+|\s+creditwolf\s+|\s+growlygo\s+|\s+sokash\s+|\s+lipalater\s+|\s+accion\s+|\s+credpal\s+|\s+credit\s*warehouse\s+|\s+masamigos\s+" \
                                     r"|\s+payfi\s+|\s+esusu\s+|\s+ansel\s+|\s+pitason\s+|\s+arkounting\s+|\s+aposhamura\s+|\s+evolve\s+|\s+zilla\s+|\s+coralstone\s+|\s+arnergy\s+|\s+eazylender\s+|\s+shagoral\s+|\s+bancorp\s+|\s+credive\s+|\s+beta\s*car\s+|\s+klip\s*pay\s+|\s+yahshud\s+|\s+goldenox\s+|\s+fuel\s*credit\s+" \
                                     r"|\s+sokowatch\s+|\s+tripodbase\s+|\s+fluna\s+|\s+credit\s*direct\s+|\s+fluna\s+|\s+daxlinks\s+|\s+waka\s*credit\s+|\s+gypsy\s+|\s+credite\s+|\s+lenvisery\s+|\s+momoney\s+|\s+rosabon\s+|\s+cool\s*bucks\s+|\s+tfs\s*finance\s+|\s+quickcheck\s+|\s+soko\s*loan\s+|\s+specta\s+|\s+loanspot\s+|\s+kiakia\s+" \
                                     r"|\s+zero\s*degree\s+|\s+inflow\s*finance\s+|\s+king\s*aledura\s+|\s+auto\s*check\s+|\s+microfinance\s*bank\s+|overdraft\s+|\s+xgo\s*technologies\s+|\s+cashtree\s+|\s+bytefin\s+|\s+cashigo\s+|\s+lapo\s+|\s+longan\s+|\s+lunago\s+|\s+borrow\s*first\s+|\s+genium\s*credit\s+" \
                                     r"|\s+credit\s*wolf\s+|\s+easycheck\s+|\s+quick\s*check\s+|\s+fairmoney\s+|\s+cash\s*asap\s+|\s+faircash\s+|\s+mscapital\s+|\s+nodcredit\s+|\s+windville\s+|\s+rock\s*financials\s+|\s+otp\s*internet\s*tech\s+|\s+umba\s+|salary\s+advance|settlement\sapprove|\s+carbon\s+mfb\s+"

gambling_keywords = r'bet(?!a|t|h|w|o|e|i|m|r|u|y)|sv\s+gaming|konfam\s*bonus\s*gaming|peripesa|888\s*sport' \
                            r'|frapapa|parimatch|sportpesa|milestone\s*gaming|odibets|\s+betika\s+|\s+betwinner\s+|\s+betway\s+' \
                            r'bet(?!a|t|h|w|o|e|i|m|r|u|y)|sv\s+gaming|konfam\s*bonus\s*gaming|peripesa|888\s*sport|frapapa|parimatch'\
                            r'|milestone\s*gaming|sportpesa|afriplay|arcadia|yangawin|wow\s+lotto|winlot|western\s+lotto|wescobet|ubc365|wakabet'\
                            r'|tradefada|topsports|schoolme\s+lottery|refpredictor|lotto|plentymillions|ogamanager|ochala\s+limited|msport|megamillions'\
                            r'|luckybet|alphagram\s+west\s+africa|eg&h\s+integrated|lotgrand|\s+logam\s+|mywin247|kickoff102|home\s+lottery|incentive\s+games'\
                            r'|effizycash|dice|\s+crsg\s+pools\s+|chopbarh|booster99|bid9ja|betika|gaming|Kagwirawo|Bongobongo'    

transfer_keywords = r'transf(?!er\slevy)|trf|tnf|trsf|trtr|fip|nip|neft|nibss|tsf\s+|trnsf|trnf|mob2|send\s*money\s*'\
                            r'mobile\s*money\s*tr|transfer(?!\slevy)'

atm_keywords = r'atm|terminal\s+'

pos_keywords = r'pos[\s+|\/|@]+|point.*of.*sale'

online_and_web_keywords = r'(?:web\s*(?:pay|purc|pur|paid|.*onlin|:[\d|\w|\s]*|pmnt|pmt)|online\s*(?:pay|pmnt|pmt|international\s+money\s+transfer|paid|pur|:[\d|\w|\s]*))'

ussd_keywords = r'ussd'

airtime_keywords = r'air\s*time|glo([\s+|_|@|\/|\\|:]+)|mtn([\s+|_|@|\/|\\|:]+)|9mobile|airtel|vtu|topup|etisalat'
                            

internet_data_keywords = r'spectranet| data\s*sub|ipnx|tizeti|bundles|faiba\s+|telkom|skynet|tabana|innovis\s*telecom|safaricomhome|safaricomhome|ussd\s\w+\s\d{13}'

# utilities_keywords = r'dstv|tstv|prepaid(?!\s*card)|postpaid(?!\s*card)|cable\s*tv|star\s*times|mytv|gotv|electric|utility'\
#                             r'|kplc|kenya\s*power|sanitation|showmax|\s+actv\s+|\s+cantv\s+|iroko\s+tv|trendtv|cable\s+television|infinity\s+tv|\s+daarsat\s+'\
#                             r'|\s+ovamann\s+|solar\s+energy|\s+phcn\s+|\s+zlga\s+|water|\s+kplc\s+|utilit|\s+kedco\s+|\s+kisumu\s+|\s+lumos\s+|\s+nawec\s+|\s+tawasco\s+|\s+phed\s+|\s+ibedc\s+|\s+ekedp\s+'\
#                             r'|\s+ekedc\s+|\s+cofred\s+|\s+aedc\s+|\s+bedc\s+|\snwsc\s|\sumeme\s|\syaka\s'

transportation_keywords = r'uber|bolt|cab\s+|taxi\s+|taxify|plentywaka|indriver|logistics|aero\s+|airline|travel'\
                            r'|airway|air\s+|aviance|jefa\s+|ucoel\s+pay|wakanow|rwandair|emirates\s+|hotel\s+booking|slim\s+trader|smatmove|outdoors\s+tour|\s+sprym\s+'\
                            r'|tranzit|travelbeta|gig\s+mobility|chisco\s+transport|ecobank\s+easy\s+fuel|lekki\s+concession|parizzo\s+ride|rivers\s+state\s+motor'

health_keywords = r'hospital|clinic|pharmacy|pharmaceuticals|dental'

travel_keywords = r'travel|airline|flight|railway|train(?!ing)'

# entertainment_keywords = r'movie|cinema|games|netflix|streaming|apple\s*music|spotify|youtube|hulu|deezer|boomplay|audiomack'\
#                             r'|entertainment|mall'

# hospitality_and_food_keywords = r'restaurant|hotel|food|drink\s+|lounge\s+|bar\s+|\s+kfc\s+|resort|salon|barber|pub\s+|eatery|supermarket\s'\
#                                 r'|naivas|wine\s+|chicken\s+inn|cuisine|pizza|mart\s+|artcaffe|whisky|chicken\s+hut|carrefour|\s+grill\s+|\s+club\s+|entertainment|café'\
#                                 r'|cinemax|sheraton|golden\stulip|bandali|marriot|mestil|caliente|latitude\s256|mall|shoprite'

insurance_keywords = r'insurance'

religious_keywords = r'tithe|offering'

rent_keywords = r'\s+rent'

fitness_keywords = r'gym'

waste_and_water_keywords = r'\s+water\s+|\s+waste\s+'

bars_lounge_club_keywords = r'bar|lounge|s+club\s+'

grocery_and_malls_keywords = r'grocery|naivas|mart\s+|mall|shoprite'

tv_and_streaming_subscription_keywords = r'dstv|tstv|cable\s*tv|star\s*times|mytv|gotv|showmax|\s+actv\s+|\s+cantv\s+|iroko\s+tv|trendtv|cable\s+television|infinity\s+tv|\s+daarsat\s+'

food_and_drinks_keywords = r'food|wine\s+|chicken\s+inn|cuisine|pizza|artcaffe|whisky|chicken\s+hut|carrefour|\s+grill\s+'

electricity_keywords = r'\s+phcn\s+|electric|\s+aedc\s+|\s+bedc\s+|\s+ibedc\s+|\s+ekedp\s+'

charges_and_stamp_duty_keywords = r'\s+charge\s+|stamp\s*duty|card\s*maint|wtax|card\s+issuance\s+fee|excise\s+duty|loop\s+commission|stamp\s*duties|sms\s*alert\s*fee'\
                                r'|account\s*maintenance\s*fee\ |bill\s*payment\s*fee|eft\s*comm|service\s*fee|cash\s*withdrawal\s*fee|comm\s*on\s*inward\s*credit|transfer\s*levy'

international_transactions_keywords = r'paypal|amazon\s*pay|skrill|stripe|payza|bluesnap|braintree|securionpay|2checkout|authorize\.net|cellulant'

savings_and_investments_keyword =  r'piggy\s*vest|cowrwise|bamboo|trove|chaka|passfolio|rise\s*technologies|\s*invest|lock\s*saving'

