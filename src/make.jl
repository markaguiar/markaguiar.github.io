using YAML
using Dates


cd("$(homedir())/Github/markaguiar.github.io/src/")

src_dir = "."
root_dir = ".."
subpage_dir = "citation"
subpage_path = joinpath(root_dir, subpage_dir)

header_pubs = """---
layout: single
author_profile: true
toc: true
toc_label: Papers
title: Research
canonical_url: "https://markaguiar.github.io/"
---

"""

@info "Reading papers database"

papers = reverse(YAML.load(open(joinpath(src_dir, "papers.yaml"))))

link_str(a, b; pre="", post="") = pre * "[$a]($b)" * post

bibtex(s) = "\t" * join(split(s, "\n"), "\n\t\t")

permalink(s) = "/" * subpage_dir * "/" * s

@info "Generating research page"

open(joinpath(root_dir, "index.md"), "w") do io
    write(io, header_pubs)

    write(io, "## Recent Keynote Lectures\n")
    write(io, "* " * "2023 IMF Mundell-Fleming Lecture " * link_str("video",  "https://www.imf.org/en/videos/view?vid=6340896615112"
    , post=",  ") * link_str("Slides",  "https://markaguiar.github.io/files/MFpresentation.pdf", post=", ") 
    * link_str("Written Remarks",  "https://markaguiar.github.io/files/MFwriteup.pdf"
    , post=", ") * link_str("Short Piece in IMF's F&D Magazine", "https://www.imf.org/en/Publications/fandd/issues/2024/06/The-Poisoned-Chalice-of-Debt-Mark-Aguiar?utm_medium=email&utm_source=govdelivery", post=", ")* link_str("Podcast",  "https://www.imf.org/en/News/Podcasts/All-Podcasts/2024/08/08/mark-aguiar-on-debt", post="\n\n"))

    write(io, "* " * "2023 SED Plenary " * link_str("video",  "https://youtu.be/aROa97zqNzQ"
    , post=",  ") * link_str("Slides",  "https://markaguiar.github.io/files/SEDpresentation.pdf", post="\n\n")  )


    write(io, "## Books\n")
    for p in papers
        if p["published"]=="book" && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  "https://press.princeton.edu/books/hardcover/9780691176819/the-economics-of-sovereign-debt-and-default"
            , post="\n\n"))
            write(io,"[ <center>  <img  loading=\"lazy\" src=\"https://pup-assets.imgix.net/onix/images/9780691176819.jpg?auto=format\" srcset=\"https://pup-assets.imgix.net/onix/images/9780691176819.jpg?w=200&amp;auto=format 200w, https://pup-assets.imgix.net/onix/images/9780691176819.jpg?w=400&amp;auto=format 400w, https://pup-assets.imgix.net/onix/images/9780691176819.jpg?w=600&amp;auto=format 600w, https://pup-assets.imgix.net/onix/images/9780691176819.jpg?w=800&amp;auto=format 800w, \" width=\"300\" sizes=\"(min-width: 1440px) 410px, (min-width: 1280px) calc((((100vw - 560px) / 12) * 4) + 120px), (min-width: 1024px) calc((((100vw - 424px) / 12) * 4) + 90px), (min-width: 768px) calc((((100vw - 408px) / 12) * 4) + 90px), (min-width: 568px) calc((((100vw - 268px) / 12) * 12) + 220px),  calc((((100vw - 140px) / 6) * 6) + 100px)\"> </center>](https://press.princeton.edu/books/hardcover/9780691176819/the-economics-of-sovereign-debt-and-default)
            \n")

        end
    end


    write(io, "## Working Papers\n")
    for p in papers
        if p["published"]=="wp" && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
                join(io, lst, " -- ") 
            end 
            write(io, "\n")
        end
    end

    write(io, "\n\n")
    write(io, "## Journal Publications\n\n")
#    write(io, "[BibTeX file](http://markaguiar.github.io/files/ref.bib)\n\n")

    for p in papers
        if p["published"]=="journal" && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))
            push!(lst, link_str("Journal link", p["journal"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            push!(lst, link_str("BibTeX and abstract", permalink(p["permalink"])))
            join(io, lst, " -- ")
            write(io, "\n\n")
        end
    end

    write(io, "\n\n")
    write(io, "## Handbook Chapters\n\n")
#    write(io, "[BibTeX file](http://markaguiar.github.io/files/ref.bib)\n\n")

    for p in papers
        if p["published"]=="handbook" && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))
            push!(lst, link_str("Journal link", p["journal"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            push!(lst, link_str("BibTeX and abstract", permalink(p["permalink"])))
            join(io, lst, " -- ")
            write(io, "\n\n")
        end
    end


    write(io, "\n\n")
    write(io, "## Conference Volumes\n\n")
#    write(io, "[BibTeX file](http://markaguiar.github.io/files/ref.bib)\n\n")

    for p in papers
        if p["published"]=="conference" && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))
            push!(lst, link_str("Journal link", p["journal"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            push!(lst, link_str("BibTeX and abstract", permalink(p["permalink"])))
            join(io, lst, " -- ")
            write(io, "\n\n")
        end
    end

    write(io, "\n\n")
    write(io, "## Other Publications\n\n")

    for p in papers
        if p["published"]=="other" && p["show_on_website"] 
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))
            push!(lst, link_str("Journal link", p["journal"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            push!(lst, link_str("BibTeX and abstract", permalink(p["permalink"])))
            join(io, lst, " -- ")
            write(io, "\n\n")
        end
    end


    write(io, "\n\n")
    write(io, "## Published Discussions\n\n")
    for p in papers
        if p["published"]=="discussion" && p["show_on_website"]
            write(io, "* " * link_str(p["title"],  permalink(p["permalink"]), post="\n\n"))
            write(io, "    " * p["citation"] * "\n")
            lst = String[]
            push!(lst, link_str("PDF", p["PDF"]))            
            push!(lst, link_str("Journal link", p["journal"]))
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            push!(lst, link_str("BibTeX and abstract", permalink(p["permalink"])))
            join(io, lst, " -- ") 
        write(io, "\n")
        end
    end
end





# Generating the subpages 

function header_subpage(title, permalink)
    return "---\nlayout: single \nauthor_profile: true \ntitle: $title \npermalink: $permalink\nexclude: true\n---\n\n"
end 

@info "Generating subpages"

for p in papers
    if  p["published"]!="book" && p["show_on_website"] #&& p["published"]
        @info "   -> " * p["title"]
        file = joinpath(subpage_path, p["permalink"] * ".md")
        open(file, "w") do io
            write(io, header_subpage(p["title"], permalink(p["permalink"])))
            lst = String[]
            
            push!(lst, link_str("PDF", p["PDF"]))
            if   p["published"]!="wp"
                push!(lst, link_str("Journal link", p["journal"]))
            end
            if haskey(p, "other_links")
                for l in p["other_links"]
                    s = link_str(l["link_text"], l["url"])
                    if haskey(l, "extra")
                        s = s * " $(l["extra"])"
                    end 
                    push!(lst, s)
                end
            end 
            join(io, lst, " -- ")

            write(io, "\n#### Citation\n\n")
            write(io, p["citation"] * "\n\n")
            if haskey(p, "abstract")
                write(io, "#### Abstract\n\n")
                write(io, p["abstract"])
            end 
            if   p["published"]!="wp"
                write(io, "\n\nBibTeX Cite:\n\n")
                write(io, bibtex(p["bibtex"]))
            end
        end
    end
end 


# # Generating the CV 

 @info "Generating CV"

cv_header = """---
layout: single
author_profile: false
title: Mark Aguiar
canonical_url: "https://markaguiar.github.io/cv/"
---"""

open(joinpath(root_dir, "CV/index.md"), "w") do io
    write(io, cv_header)
    write(io, "\n")
    write(io, "*updated on " * string(Date(now())) * "* \n\n")
    write(io, read(joinpath(src_dir, "cv_part1.md"), String))
    write(io, "\n")
    write(io, "## Books\n\n")
    for p in papers
        if   p["published"]=="book"
            write(io, "- " * p["citation"] * "\n\n")
        end
    end
    write(io, "## Journal Publications\n\n")
    for p in papers
        if   p["published"]=="journal"
            write(io, "- " * p["citation"] * "\n\n")
        end
    end
    write(io, "## Handbook Chapters\n\n")
    for p in papers
        if   p["published"]=="handbook"
            write(io, "- " * p["citation"] * "\n\n")
        end
    end
    write(io, "## Conference Volumes\n\n")
    for p in papers
        if   p["published"]=="conference"
            write(io, "- " * p["citation"] * "\n\n")
        end
    end
    write(io, "## Miscellaneous Publications\n\n")
    for p in papers
        if   p["published"]=="other"
            write(io, "- " * p["citation"] * "\n\n")
        end
    end
    write(io, "## Published Discussions\n\n")
    for p in papers
        if   p["published"]=="discussion"
            write(io, "- " * p["citation"] * "\n\n")
        end
    end
    write(io, "## Working Papers\n\n")
    for p in papers
        if   p["published"]=="wp"
            write(io, "- " * p["citation"] * "\n\n")
        end
    end
    write(io, read(joinpath(src_dir, "cv_part2.md"), String))
    write(io, "\n")
end

@info "Done with CV"

#Write bibtex file

@info "Generating Bibtex files"

open("ref_book.bib", "w") do io
    for p in papers
        if   p["published"]=="book"
            write(io, p["bibtex"]* "\n\n")
        end
    end
end
open("ref_pub.bib", "w") do io
    for p in papers
        if   p["published"]=="journal"
            write(io, p["bibtex"]* "\n\n")
        end
    end
end
open("ref_conf.bib", "w") do io
    for p in papers
        if   p["published"]=="conference"
            write(io, p["bibtex"]* "\n\n")
        end
    end
end
open("ref_HB.bib", "w") do io
    for p in papers
        if   p["published"]=="handbook"
            write(io, p["bibtex"]* "\n\n")
        end
    end
end
open( "ref_other.bib", "w") do io
    for p in papers
        if   p["published"]=="other"
            write(io, p["bibtex"]* "\n\n")
        end
    end
end 
open("ref_disc.bib", "w") do io
    for p in papers
        if   p["published"]=="discussion"
            write(io, p["bibtex"]* "\n\n")
        end
    end
end
open( "ref_wp.bib", "w") do io
    for p in papers
        if   p["published"]=="wp"
            write(io, p["bibtex"]* "\n\n")
        end
    end
end 
 


@info "Done with Bibtex files"

@info "compile CV to pdf"
 
run(`pdflatex cv`)
run(`bibtex book`)
run(`bibtex pub`)
run(`bibtex hb`)
run(`bibtex conf`)
run(`bibtex other`)
run(`bibtex disc`)
run(`bibtex wp`)
run(`pdflatex cv`)
run(`pdflatex cv`)

run(`cp cv.pdf ../CV/`)

 
for x in [".aux",".blg",".bbl",".out",".log",".fls","latexmk"]
    foreach(rm, filter(endswith(x), readdir()))
end

@info "done with compile CV to pdf"


